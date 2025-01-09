# DIAL's Digital Impact Exchange

The Digital Impact Exchange is an interactive online resource to support donors,
governments, and procurers in the development and implementation of digital strategies.​
The Exchange aggregates data from a variety of sources (including the Digital Public
Goods Alliance, WHO, Digital Square and the DIAL Open Source Center) and allows the
user to identify and evaluate digital tools that may be applicable for their use cases
or projects.

The catalog supports the [SDG Digital Investment Framework](https://digitalimpactalliance.org/research/sdg-digital-investment-framework/) developed by DIAL and ITU.

## Repositories

Note that this repository contains the code for the back-end/API for the Exchange. The front-end
code for the Exchange can be referenced at:
https://gitlab.com/dial/digital-impact-exchange/exchange-front/-/tree/development

## Documentation

Complete documentation is available (including detailed installation and configuration
instructions) at
[https://docs.dial.community/projects/product-registry/en/latest/](https://docs.dial.community/projects/product-registry/en/latest/ "DIAL's Digital Impact Exchange Documentation")

Please also reference the [Wiki page for the Exchange](https://digital-impact-exchange.atlassian.net/wiki/spaces/SOLUTIONS/overview?homepageId=33072), which contains information about upcoming feature development, releases, and additional documentation.

## Development environment setup
Development environment can be either semi-containerized using Docker or non-containerized. Containerized environment is faster to set up, hence it is a recommended approach.

---
## Semi-containerized setup using Docker
This approach does not require installing PostgreSQL or Redis manually on the system, because they will be installed and run in Docker containers.

### **Step 1** - Install dependencies
* Required dependencies:
  ```sh
  sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev
  ```
* `Ruby` (version 2.5 or greater) - see [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) for installation instructions.
* `Bundler` - install by executing the following command in a terminal: ```gem install bundler:2```
* `Rails` (version 5.2) - once Ruby is installed, you can install Rails using the following command in a terminal: ```gem install rails```
* `Docker` - see [Get Docker](https://docs.docker.com/get-docker/) for installation instructions. Once installed follow [these instructions](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) to manage docker as non-root user.

### **Step 2** - Install the dependencies specified in Gemfile
Execute the following command in a terminal:
```sh
bundle install
```

#### **Troubleshooting**
If the command fails you might have to install additional libraries using the following command:
```sh
gem install <package> -v <package version> --source 'https://rubygems.org/' --user-install
```

### **Step 3** - Set environment variables
First, create a **setEnv.sh** file. Then, log in and request access to [Confluence Onboarding Page](https://digital-impact-exchange.atlassian.net/wiki/spaces/SOLUTIONS/pages/196575233/New+Developer+Onboarding). On this page find a sample **setEnv.sh** file. Finally, copy the contents of the sample **setEnv.sh** file and paste it into your new file.

Now, in your terminal session, run the **setEnv.sh** script to set environment variables by executing the following command:

```sh
source ./setEnv.sh dev
```

**Note:** Running this command will set the environment variables for the current terminal session only. Any time you open a new terminal window (or reboot), you have to run this command again.

### **Step 4** - Run PostgreSQL and Redis in Docker containers
In the terminal, with environment variables set, execute the following commands:

```sh
docker-compose -f deploy/docker-compose-dev.yml up -d
```

#### **Troubleshooting**
If you encounter the following error in the terminal:
```sh
listen tcp4 0.0.0.0:<POSTGRES_PORT>: bind: address already in use
```

for example, if `POSTGRES_PORT` environment variable is set to `1234`:
```sh
listen tcp4 0.0.0.0:1234: bind: address already in use
```

then execute the following to find a process that uses this port:
```sh
sudo lsof -i -P -n | grep 1234
```

and kill the process by passing its `id` as an argument to:
```sh
sudo kill -9 <id>
```

### **Step 5** - Create or restore database from database dump file
You can ask repository's maintainers for a database dump file.

If you **do have a dump file** follow these instructions:
1. Move the `registry.dump` (rename the file if its name is different) database dump file to `/db/backups` directory
2. Execute the following command in the terminal:
    ```sh
    rails db:restore
    ```
3. (Optional) to additionally feed the test database execute the following command in the terminal:
    ```sh
    rails db:restore RAILS_ENV=test
    ```

**Otherwise**, follow these instructions:
1. Execute the following commands in the terminal:
    ```sh
    rails db:create
    rails db:schema:load
    rails db:seed
    ```

### **Step 6** - Run database migrations
Execute the following command in the terminal:
```sh
rails db:migrate
```

(Optional) to additionally run migrations of test database, execute the following command in the terminal:
```sh
rails db:restore RAILS_ENV=test
```

### **Step 7** - Start Puma web server
Puma web server comes bundled with Rails. Execute the following command in the terminal:
```sh
rails server
```

Once executed, Puma server should be up and running. The application will run on localhost port `3000` by default.

The following is an expected example output:
```
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 58848
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

### **Further steps** - Starting the development environment
Once the development environment has been set up and run once, fewer steps are required to start the environment.
1. Run `source setEnv.sh dev` to set all mandatory environment variables.
2. Run `docker-compose -f deploy/docker-compose-dev.yml up -d` to run PostgreSQL and Redis in Docker containers.
3. Run `rails server` to start Puma server.

### **Further steps** - Stopping the development environment
* To stop Puma server, press CTRL + C.
* To stop Docker containers, execute the following command in the terminal:
    ```
    docker-compose -f docker-compose-dev.yml down
    ```

---

## Non-containerized setup

### **Step 1** - Install dependencies
* Required dependencies:
  ```sh
  sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev
  ```
* `Ruby` (version 2.5 or greater) - see [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) for installation instructions.
* `Bundler` - install by executing the following command in a terminal: ```gem install bundler:2```
* `Rails` (version 5.2) - once Ruby is installed, you can install Rails using the following command in a terminal: ```gem install rails```
* `PostgreSQL` (version 12 or higher) - see [PostgreSQL Download](https://www.postgresql.org/download/) for download and installation instructions.

### **Step 2** - Install the dependencies specified in Gemfile
Execute the following command in a terminal:
```sh
bundle install
```

#### **Troubleshooting**
If the command fails you might have to install additional libraries using the following command:
```sh
gem install <package> -v <package version> --source 'https://rubygems.org/' --user-install
```

### **Step 3** - Set environment variables
First, create a **setEnv.sh** file. Then, log in and request access to [Confluence Onboarding Page](https://digital-impact-exchange.atlassian.net/wiki/spaces/SOLUTIONS/pages/196575233/New+Developer+Onboarding). On this page find a sample **setEnv.sh** file. Finally, copy the contents of the sample **setEnv.sh** file and paste it into your new file.

Now, in your terminal session, run the **setEnv.sh** script to set environment variables by executing the following command:

```sh
source ./setEnv.sh dev
```

**Note:** Running this command will set the environment variables for the current terminal session only. Any time you open a new terminal window (or reboot), you have to run this command again.

### **Step 4** - Configure PostgreSQL
Before running the application, you have to create a user in PostgreSQL whose username and password must align with the `POSTGRES_USER` and `POSTGRES_PASSWORD` environment variables respectively.

To create a user in PostgreSQL, connect to PostgreSQL by executing the following command in the terminal:
```sh
psql postgres
```

Run the following commands in `psql` interactive terminal:
```sh
create user <POSTGRES_USER> with password '<POSTGRES_PASSWORD>';
alter user <POSTGRES_USER> with superuser;
```

for example, if `POSTGRES_USER` environment variable is set to `abc` and `POSTGRES_PASSWORD` to `123` then the command would look as follows:
```sh
create user abc with password '123';
alter user abc with superuser;
```
#### **Troubleshooting**
If you are unable to connect to the postgres database, please ensure that the configuration in the `pg_hba.conf` file is correct.
You can find the file in the PostgreSQL installation directory (MacOSX: `/Library/PostgreSQL/<POSTGRESQL VERSION>/data`, Ubuntu: `/etc/postgresql/<POSTGRESQL VERSION>/main`). Ensure that the `METHOD` column for all connections is set to `'trust'`. By default, it is set to `'md5'`.

### **Step 5** - Create or restore database from database dump file
You can ask project's maintainers for a database dump file.

If you **do have** a dump file follow these instructions:
1. Move the `registry.dump` (rename the file if its name is different) database dump file to `/db/backups` directory
2. Execute the following command in the terminal:
    ```sh
    rails db:restore
    ```
3. (Optional) to additionally feed the test database execute the following command in the terminal:
    ```sh
    rails db:restore RAILS_ENV=test
    ```

Otherwise, follow these instructions:
1. Execute the following commands in the terminal:
    ```sh
    rails db:create
    rails db:schema:load
    rails db:seed
    ```

### **Step 6** - Run database migrations
Execute the following command in the terminal:
```sh
rails db:migrate
```

(Optional) to additionally run migrations of test database, execute the following command in the terminal:
```sh
rails db:restore RAILS_ENV=test
```

### **Step 8** - Start Puma web server
Puma web server comes bundled with Rails. Execute the following command in the terminal:
```sh
rails server
```

Once executed, Puma web server should be up and running. The application will run on localhost port `3000` by default.

The following is an expected example output:
```sh
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 58848
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

### **Further steps** - Starting the development environment
Once the development environment has been set up and run once, fewer steps are required to start the environment.
1. Run `source setEnv.sh dev` to set all mandatory environment variables.
2. Run `rails server` to start Puma server.

### **Further steps** - Stopping the development environment
* To stop Puma server, press CTRL + C.

---
## Useful commands
### Connect to PostgreSQL database run in a Docker container
If you set up the development environment using the semi-containerized approach, execute the following command to connect to the database:
```sh
psql -h localhost -U <POSTGRES_USER> -W <POSTGRES_DB>
```

where `POSTGRES_USER` and `POSTGRES_DB` are environment variables set is `setEnv.sh` file.

### Create a database dump file (backup)
In order to create database dump file from your current database content, execute the following command:
```sh
rails db:backup
```
The dump file will be stored saved in `db/backups` directory.

### Create GraphQL schema dump

To create GraphQL schema dump, execute the following command:
```sh
rails graphql:schema:dump
```

### Run unit tests
In order to run unit tests, execute the following command:
```sh
bundle exec rspec
```

### Run Rubocop
To run Rubocop linter, execute the following command:
```sh
bundle exec rubocop
```

## Standardized GraphQL Structure

### Returning Object

Object field in a type or GraphQL returning object will always return the object or nil value by setting the parameter ```null: true```. This will allow the field or the returned data to always be there instead of returning GraphQL error to the front-end when the object's value is nil.

Example:

```ruby
# From organization_type.rb
field :endorser_level, String, null: true

# From product_type.rb
field :main_repository, Types::ProductRepositoryType, null: true
```

When the ```endorser_level``` or ```main_repository``` is nil, the front-end will receive:

```json
{
    "data": {
        "organization": {
            "endorser_level": null
        }
    }
}
```

```json
{
    "data": {
        "product": {
            "mainRepository": null
        }
    }
}
```

The following ```find_by``` will return ```nil``` if the slug record is not in the database. Without ```null: true```, the query will return GraphQL error to the front-end because the resolver is expecting non-null value.

```ruby
# From products_query.rb
class ProductQuery < Queries::BaseQuery
  argument :slug, String, required: true

  type Types::ProductType, null: true

  def resolve(slug:)
    Product.find_by(slug: slug)
  end
end
```

When the ```find_by``` return nil, the front-end will receive:

```json
{
    "data": {
        "productQuery": null
    }
}
```

### Returning Array

Array field in a type or GraphQL returning array will always return array of the intended objects or empty array by setting the parameter ```[ExpectedType], null: false```.

Example:

```ruby
# From organization_type.rb
field :products, [Types::ProductType], null: false
```

With this configuration, the front-end will receive the following data:

```json
{
    "data": {
        "organization": {
            "products": []
        }
    }
}
// With non-empty products array
{
    "data": {
        "organization": {
            "products": [{
                "name": "Example Product",
                "slug": "example_product"
            }, {
                "name": "Other Product",
                "slug": "other_product"
            }]
        }
    }
}
```

Another example:

```ruby
class OrganizationsQuery < Queries::BaseQuery
  argument :search, String, required: false, default_value: ''

  type [Types::OrganizationType], null: false

  def resolve(search:)
  ...
  end
end
```

With this configuration, the front-end will receive the following data:

```json
{
    "data": {
        "organizations": []
    }
}
// With non-empty search results
{
    "data": {
        "organizations": [{
            "name": "Example Organization",
            "slug": "example_organization"
        }, {
            "name": "Other Organization",
            "slug": "other_organization"
        }]
    }
}
```

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
