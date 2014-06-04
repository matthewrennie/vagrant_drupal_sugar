include_recipe "apt"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "ark"
include_recipe "database::mysql"

apache_site "default" do
  enable true
end

ark "drupal" do
   path "/var/chef/cache"
   url 'http://ftp.drupal.org/files/projects/drupal-7.15.tar.gz' 
   action :put
end

execute 'mv ./drupal /var/www/drupal' do
  cwd "#{Chef::Config[:file_cache_path]}"
  user 'root'
  group 'root'
  not_if do FileTest.directory?('/var/www/drupal') end
end

execute "set ownership of drupal to www.data" do
  command "chown -R www-data.www-data /var/www/drupal/"  
end

# create a database connection
mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# create drupal database
mysql_database 'dbdrupal' do
	connection mysql_connection_info
  action :create
end

# create drupaluse and grant all priveleges to the drupal database
mysql_database_user 'drupaluser' do
  connection    mysql_connection_info
  password      'drupalpass'
  database_name 'dbdrupal'
  host          '%'
  action        :grant
end