# pastes
Sinatra paste microservice for pastes.glitchwrks.com

This is a Sinatra microservice that provides "pastebin" style functionality on [pastes.glitchwrks.com](https://pastes.glitchwrks.com). It is currently deployed on an OpenBSD 7.6 host.

The functionality of this microservice used to be included with [rails_services](https://github.com/glitchwrks/rails_services). It was broken out to make serving it easier as we changed from `nginx` to OpenBSD's `relayd` for reverse proxying and TLS/SSL wrapping. [This commit](https://github.com/glitchwrks/rails_services/tree/b1b8353adbaeb3822158f8ceb4f817cdd6a68e22) includes the paste functionality in `rails_services`.

### Project Pieces

- Sinatra
- ActiveRecord
- Capistrano 3 for deployments
- Puma for app serving
- `json-schema` gem for API `POST` data validation

Currently using MariaDB for the database, but it uses nothing specific to MariaDB and works fine with even SQLite. It can be run as a Puma application, or directly via `ruby pastes_app.rb`.

### Pastes

Pastes are identified by an 8-character alphanumeric name. A `GET` to the root path will render the Paste's `content` as plaintext, e.g. `http://localhost:8080/abcd1234`

### API Endpoint

An API endpoint is provided at `/api/pastes` that will accept a `POST` with a JSON representation of a Paste. This endpoint is protected with HTTP Basic Auth -- make sure you're deploying with TLS/SSL!

JSON data is validated against [the JSON schema](config/paste_schema.json) using the [json-schema gem](https://rubygems.org/gems/json-schema).

Successful API `POST` will result in `201 Created` and an empty body. JSON which does not pass schema validation with result in `422 Unprocessable Content`, with a body of `Unprocessable JSON entity`. *Schema validation errors are intentionally not reported.* JSON which does pass validation but which results in model errors returns `422 Unprocesable Content` with a JSON response body describing the per-field errors.

### Quick Development Setup

Configure your development database in `config/database.yml` and run the following:

```
RACK_ENV=development rake db:reset
rake db:migrate
rake db:seed
rake user:create LOGIN=testlogin PASSWORD=testpassword
ruby paste_app.rb
```

After the above, you should be able to visit `http://localhost:8080/tstpaste` and pull down the seeded test Paste. You'll also be able to `POST` to `http://localhost:8080/api/pastes` using the HTTP Basic Auth User set up by `rake user:create`.

**NOTE:** *Do not use the `rake user:create` task in production without understanding that you may be leaving the supplied password in your shell history!*

### Test Suite

This application uses [RSpec](http://rspec.info/). To run the test suite on a new workstation, configure your test database in `config/database.yml` and do:

```
RACK_ENV=test rake db:test:prepare
rspec
```

[SimpleCov](https://github.com/simplecov-ruby/simplecov) provides code coverage reporting.

### Capistrano Tasks

To manage the Puma process on the application server, a custom Capistrano task, `puma:restart` has been defined. This task uses OpenBSD's [`doas`](https://man.openbsd.org/OpenBSD-7.6/doas) to invoke the rc-script that controls the Puma process.
