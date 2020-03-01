require 'sequel'

USER_DB = Sequel.sqlite('db/music_therapy.db')

class User < Sequel::Model(USER_DB[:users])
  plugin :json_serializer

    class << self
      def create_from_hash(params)
        self.create( {email: params["email"] } )
      end
    end

end

User.strict_param_setting = false  
