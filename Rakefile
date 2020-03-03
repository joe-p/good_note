namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel/core"
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.sqlite("db/music_therapy.db") do |db|
      Sequel::Migrator.run(db, "migrate", target: version)
    end
  end
end
