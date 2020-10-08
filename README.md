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

Once the build is complete:

```sh
# 6. Run one-time databse setup, which will be persisted across container executions by Docker's Volumes system
setup-db.sh
# 7. Start your container setup
docker-compose up
# Success!
```

If you're running this on Linux you might get into some privilege issues that can be solved using this command (tested on Ubuntu):
```sh
CURRENT_UID=$(id -u):$(id -g) docker-compose -f docker-compose.yml -f docker-compose.linux.yml up
```

- Visit your site at http://localhost:8000
- The admin interface is at http://localhost:8000/admin/ - log in with `admin` / `changeme`.

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
