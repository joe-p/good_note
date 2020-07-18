require_relative 'models/user'
class Note < Sequel::Model(DB[:notes]); end
class Activity < Sequel::Model(DB[:activities]); end