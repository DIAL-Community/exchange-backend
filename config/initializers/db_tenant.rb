current_tenant = ENV["DB_TENANT"]

shard = current_tenant === 'govstack' ? :primary_govstack : :primary

ActiveRecord::Base.connects_to database: { writing: shard, reading: shard }