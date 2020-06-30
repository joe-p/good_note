require 'sequel'

DB = Sequel.sqlite('db/music_therapy.db')
Sequel::Model.plugin :update_or_create
