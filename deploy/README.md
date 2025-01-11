# Digital Impact Exchange Docker Files

This directory contains all of the docker files to build and deploy the Exchange, both
in a development as well as production environment. It also contains the cron configuration
files for rake tasks that run to update data within the Exchange

## Dockerfiles

There are two Dockerfiles used to build the various containers needed for the Exchange. The
main Dockerfile is used to build the Exchange backend. The Dockerfile-nginx file is used to 
build the simple nginx proxy that is used in production. 

## Docker Compose Files

There are several docker compose files that are used to build the Exchange environment for
production, development, and CI/CD servers. The files are as follows:

- docker-compose.yml: This builds the Exchange system for the first production app server
- docker-compose-02.yml: This builds the Exchange system for the second (and beyond) app servers.
  The second app server uses an NFS file share to access images and assets on the first app server.
- docker-compose-nginx.yml: This builds and runs the nginx proxy for the Exchange on production
- docker-compose-nginx-dev.yml: This builds and runs the nginx proxy for the Exchange on the development server
- docker-compose-dev.yml: This builds and runs the PostgreSQL server for use on a developer machine
- docker-compose.ci.yml: This is the docker tooling for the Gitlab CI/CD pipeline

---
## Copyright Information
Copyright © 2025 Digital Impact Alliance. This program is free software: you can
redistribute it and/or modify it under the terms of the GNU Affero General
Public License as published by the Free Software Foundation, either version 3
of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <https://www.gnu.org/licenses/>.
