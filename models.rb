require_relative 'models/user'
class Note < Sequel::Model(DB[:notes]); end
