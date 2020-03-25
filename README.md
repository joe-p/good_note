# How to Run Locally
1. Clone this repo
2. Create a new branch so changes can't affect master
3. `bundle install` to install necessary gems (assuming you have Ruby installed) 
4. Create a non-commercial client_id at https://developer.spotify.com/dashboard/applications
5. Add CLIENT_ID to CLIENT_SECRET to your enviorment variables. On Linux that is done via the following commands:
```
$ export CLIENT_ID=[client_id key from spotify]
$ export CLIENT_SECRET=[client_secret key from spotify]
```
6. `rerun rackup` to run the server at http:\\\localhost:9292

 # Endpoints

## /spotify/analyze

| Method | Endpoint | Description | Example Output
|--|--|--|--|
| GET | /spotify/analyze/song/:id | Searches for a song via :id and returns its valence value. | {"valence":0.623}
| GET | /spotify/analyze/song/:id | WORK IN PROGRESS... Searches for a playlist via :id and returns the average valence for all songs. 

## /user/
| Method | Endpoint | Description | Example Output
|--|--|--|--|
GET | /user/:id | Searches for the user with the primary key that matches :id | {"id":2,"spotify_id":"monopolyman360"}

 ## /spotify/auth
| Method | Endpoint | Description |
|--|--|--|
| | /spotify/auth| Redirects user to Spotify login page then redirects them to /user/:id. This only works in a browser (this is not a RESTFUL endpoint and it does not return a JSON value). |

# Directory Structure and Files
## Top-Level Directory
| File / Directory | Description | Relevant Link(s) |
|--|--|--|
| .yardoc/ | Artifact of the yardoc auto-documentation tool. This directory can effectively be ignored. |[https://github.com/lsegal/yard](https://github.com/lsegal/yard)
| db/ | Contains the music_therapy.db SQLite database |
| migrate/ | Contains database migrations to ensure we are working with the latest database. | [https://guides.rubyonrails.org/v3.2/migrations.html](https://guides.rubyonrails.org/v3.2/migrations.html)
| models/ | Contains Sequel::Model definitions. The name of the file should correspond with the name of the mode. For example, the User model is defined in models/user.rb | [https://sequel.jeremyevans.net/rdoc/classes/Sequel/Model.html](https://sequel.jeremyevans.net/rdoc/classes/Sequel/Model.html)
| patches/ | Contains patches for the Ruby standard library and third-party gems. |
| public/ | Contains static files that can be served via Roda. For example, going to http://HOSTNAME/docs/index.html will serve public/docs/index.html | [https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Public.html](https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/Public.html)
| routes/ | Contains files leveraging Roda::RodaPlugins::HashRoutes to define what happens at specific end points. The directory structure should follow the endpoint structure as closely as possible. For example, all /spotify/... endpoints should be under the spotify/ directory. | [https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/HashRoutes.html](https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/HashRoutes.html)
| .yardopts | A file containing options for the yardoc auto-documentation tool. | [https://github.com/lsegal/yard](https://github.com/lsegal/yard)
| Gemfile | Bundler gemfile that specifies which gems are needed for this project | [https://bundler.io/](https://bundler.io/)
| Gemfile.lock | Snapshot of gems installed via bundler | [https://bundler.io/](https://bundler.io/)
| README.md | You're reading this right now |
| Rakefile | Similar to a Makefile, but for Rake/Ruby. | [https://github.com/ruby/rake](https://github.com/ruby/rake)
| config.ru | Roda is built on top of Rack, and this is the main configuration file for Rack's rackup utility that runs the server | [https://github.com/rack/rack/wiki/(tutorial)-rackup-howto](https://github.com/rack/rack/wiki/(tutorial)-rackup-howto) 
| db.rb | Essentially a header file for database-related code. Pulls in Sequel and sets the project's database as the SQLite .db file | [https://github.com/jeremyevans/sequel](https://github.com/jeremyevans/sequel)
| good_note.rb | The initial definition of the GoodNote class. Pulls in necessary Roda plugins, sets up global constants, and starts handling routes. | [https://github.com/jeremyevans/roda](https://github.com/jeremyevans/roda)
| models.rb | Header file for Sequel::Models in the models/ directory | [https://sequel.jeremyevans.net/rdoc/classes/Sequel/Model.html](https://sequel.jeremyevans.net/rdoc/classes/Sequel/Model.html)
| patches.rb | Header file for patches in patches/ directory |
| routes.rb | Header file for Roda hash_routes in routes/ directory | [https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/HashRoutes.html](https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/HashRoutes.html)



