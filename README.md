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
git clone git@github.com:saevarom/docker-wagtail-develop.git wagtail-dev
# 3. Move inside the new folder.
cd wagtail-dev/
# 4. Run the setup script. This will check out all the dependency repos.
./setup.sh
# 5. Build the containers
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
# 5. Start your container setup
docker-compose up
```

Now you have to wait a couple of minutes for the frontend container to copy `node_modules` to the shared volume. 
When you see messages from the frontend server about building styles and javascript you can continue:

```sh
frontend_1  | [11:16:05] Using gulpfile /code/wagtail/gulpfile.js
frontend_1  | [11:16:05] Starting 'styles:sass'...
frontend_1  | [11:16:05] Starting 'styles:css'...
frontend_1  | [11:16:06] Starting 'styles:assets'...
frontend_1  | [11:16:06] Starting 'scripts'...
frontend_1  | [11:16:06] Starting 'images'...
frontend_1  | [11:16:06] Starting 'fonts'...
frontend_1  | [11:16:07] Vendor CSS all files 32.92 kB
frontend_1  | [11:16:09] Finished 'styles:css' after 3.8 s
frontend_1  | [11:16:09] Finished 'images' after 3.93 s
frontend_1  | [11:16:10] Finished 'styles:assets' after 4.75 s
frontend_1  | [11:16:11] Finished 'fonts' after 5.07 s
frontend_1  | [11:16:11] Wagtail CSS all files 133.18 kB
frontend_1  | [11:16:11] Finished 'styles:sass' after 5.23 s
frontend_1  | [11:16:11] Starting 'styles'...
frontend_1  | [11:16:11] Finished 'styles' after 52 μs
frontend_1  | [11:16:11] Finished 'scripts' after 5.38 s
frontend_1  | [11:16:11] Starting 'build'...
frontend_1  | [11:16:11] Finished 'build' after 12 μs
frontend_1  | [11:16:11] Starting 'watch'...
frontend_1  | [11:16:14] Finished 'watch' after 2.8 s
```

The last remaining part is to run the migrations and load the initial data:

```sh
# 6. Run migrations
docker-compose exec web ./manage.py migrate --noinput
# 7. Load Bakerydemo data
docker-compose exec web ./manage.py load_initial_data
# 8. Update index if needed
docker-compose exec web ./manage.py update_index
# Success!
```


- Visit your site at http://localhost:8000
- The admin interface is at http://localhost:8000/admin/ - log in with `admin` / `changeme`.

What you can do
---------------

See a list of running containers

```sh
$ docker-compose ps
              Name                             Command               State           Ports
---------------------------------------------------------------------------------------------------
docker-wagtail-develop_db_1         docker-entrypoint.sh postgres    Up      5432/tcp
docker-wagtail-develop_frontend_1   /bin/sh -c cp -r /node_mod ...   Up
docker-wagtail-develop_web_1        /bin/bash -c cd /code/wagt ...   Up      0.0.0.0:8000->8000/tcp
```

You can open a django shell session

```sh
docker exec -it docker-wagtail-develop_web_1 python manage.py shell
```

You can open a shell on the web server

```sh
docker exec -it docker-wagtail-develop_web_1 bash
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