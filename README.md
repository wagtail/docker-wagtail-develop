docker-wagtail-develop
======================


A script to painlessly set up a Docker environment for development of Wagtail - inspired by [vagrant-wagtail-develop](https://github.com/wagtail/vagrant-wagtail-develop)

Initial work in Bristol sprint January 2020 by [esperk](https://github.com/esperk) and [saevarom](https://github.com/saevarom).

Setup
-----

**Requirements:** [Docker](https://www.docker.com/) and Docker Compose (Docker Compose is included with Docker Desktop for Mac and Windows).

Open a terminal and follow those instructions:

```sh
# 1. Decide where to put the project. We use "~/Development" in our examples.
cd ~/Development
# 2. Clone the docker-wagtail-develop repository in a new "wagtail-dev" folder.
git clone git@github.com:wagtail/docker-wagtail-develop.git wagtail-dev
# 3. Move inside the new folder.
cd wagtail-dev/
# 4. Run the setup script. This will check out all the dependency repos.
./setup.sh
# 5. Configure your app to use PostgreSQL via the DATABASE_URL from docker-compose.yml
cp bakerydemo/bakerydemo/settings/local.py.docker-compose-example bakerydemo/bakerydemo/settings/local.py
echo "DJANGO_SETTINGS_MODULE=bakerydemo.settings.local" > bakerydemo/.env
# 6. Build the containers
docker-compose build
```

It can take a while (typically 15-20 minutes) to fetch and build all dependencies and containers.

Here is the resulting folder structure:

```sh
.
├── libs          # Supporting libraries to develop Wagtail against.
├── wagtail       # Wagtail repository / codebase.
└── bakerydemo    # Wagtail Bakery project used for development.
```

Once setup is over,

```sh
# 7. Start your container setup
docker-compose up
# Success!
```

- Visit your site at http://localhost:8000
- The admin interface is at http://localhost:8000/admin/ - log in with `admin` / `changeme`.

### Debugging

If you're running this on Linux you might get into some privilege issues that can be solved using this command (tested on Ubuntu):
```sh
CURRENT_UID=$(id -u):$(id -g) docker-compose -f docker-compose.yml -f docker-compose.linux.yml up
```

#### Debugging data migrations / data loading

Sometimes there are model changes in Wagtail that require migrations to be created in the bakerydemo project. If so, you may see errors like the example below:

```
web_1       |   Applying wagtailusers.0009_userprofile_verbose_name_plural... OK
db_1        | 2020-08-01 17:45:49.722 UTC [54] ERROR:  column base_formfield.clean_name does not exist at character 58
db_1        | 2020-08-01 17:45:49.722 UTC [54] STATEMENT:  SELECT COUNT(*) AS "__count" FROM "base_formfield" WHERE "base_formfield"."clean_name" = ''
db_1        | 2020-08-01 17:45:50.195 UTC [54] ERROR:  column "clean_name" of relation "base_formfield" does not exist at character 47
web_1       | Traceback (most recent call last):
web_1       |   File "/usr/local/lib/python3.7/site-packages/django/db/backends/utils.py", line 86, in _execute
web_1       |     return self.cursor.execute(sql, params)
web_1       | psycopg2.errors.UndefinedColumn: column "clean_name" of relation "base_formfield" does not exist
web_1       | LINE 1: UPDATE "base_formfield" SET "sort_order" = 0, "clean_name" =...
```

To fix this, open a new terminal window, exec into the container and run makemigrations:

```
docker exec -it wagtail-dev_web_1 /bin/bash`
`./manage.py makemigrations`
```

Then, back in your original terminal window, stop the server (with CONTROL-C), and rerun `docker-compose up`.

What you can do
---------------

### See a list of running containers

```sh
$ docker-compose ps
              Name                             Command               State           Ports
---------------------------------------------------------------------------------------------------
docker-wagtail-develop_db_1         docker-entrypoint.sh postgres    Up      5432/tcp
docker-wagtail-develop_frontend_1   /bin/sh -c cp -r /node_mod ...   Up
docker-wagtail-develop_web_1        /bin/bash -c cd /code/wagt ...   Up      0.0.0.0:8000->8000/tcp
```

### You can open a django shell session

```sh
docker-compose exec web python manage.py shell
```

### You can open a shell on the web server

```sh
docker-compose exec web bash
```

### You can open a shell to work with the frontend code (Node/NPM)

```sh
docker-compose exec frontend bash
```

Getting ready to contribute
---------------------------

Here are other actions you will likely need to do to make your first contribution to Wagtail.

Set up git remotes to Wagtail forks (run these lines outside of the Docker instances, on your machine):

```sh
cd ~/Development/wagtail-dev/wagtail
# Change the default origin remote to point to your fork.
git remote set-url origin git@github.com:<USERNAME>/wagtail.git
# Add wagtail/wagtail as the "upstream" remote.
git remote add upstream git@github.com:wagtail/wagtail.git
# Pull latest changes from all remotes / forks.
git pull --all
```


TODO
----

* Set up an elasticsearch service container
* Test on Windows and Linux
