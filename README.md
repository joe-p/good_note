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
