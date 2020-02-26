# How to Run
1. Clone this repo
2. Create a new branch so changes can't affect master
3. `bundle install` to install necessary gems (assuming you have Ruby installed) 
4. Create a non-commercial client_id at https://developer.spotify.com/dashboard/applications
5. Create a spotify.yml file in the project's root directory with your client_id and client_secret keys from step 3 (this file should remain in the .gitignore so the client_secret remains secret)
```
client_id: <whatever your client_id is>
client_secret: <whatever your client_secret is>
```
6. `rerun rackup` to run the server at http:\\\localhost:9292
