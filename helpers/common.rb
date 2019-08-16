require_relative '../lib/dependencies'

def connect_database
  ActiveRecord::Base.establish_connection(
    adapter: 'postgresql',
    host: ENV['DB_HOST'],
    database: 'freshly_development',
    username: ENV['DB_USER'],
    password: ENV['DB_PASS']
  )
end
