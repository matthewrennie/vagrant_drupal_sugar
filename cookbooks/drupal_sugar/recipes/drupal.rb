include_recipe "apt"
include_recipe "ark"
include_recipe "database::mysql"

apt_package "install php gd" do
  package_name "php5-gd"
  action :install
end

ark "drupal" do
   path "/var/chef/cache"
   url 'http://ftp.drupal.org/files/projects/drupal-7.15.tar.gz' 
   action :put
end

execute 'cp -R ./drupal /var/www/drupal' do
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

execute "restart apache" do
  user "root"
  command "service apache2 restart"  
end