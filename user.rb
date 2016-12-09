ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(
	adapter: 'sqlite3',
	database: 'development.sqlite3'
	)

class User < ActiveRecord::Base
end