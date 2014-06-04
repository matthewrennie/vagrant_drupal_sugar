include_recipe "apt"
include_recipe "ark"
include_recipe "database::mysql"

bash "download and extract SugarCRM community edition" do
     user "vagrant"
     cwd "/var/chef/cache"
     code <<-EOH
       wget wget -O sugar.zip http://sourceforge.net/projects/sugarcrm/files/latest/download?source=files
       unzip sugar.zip
       mv ./SugarCE-Full-6.5.16 ./sugar
     EOH
     not_if "test -d /var/chef/cache/sugar"
end

execute 'cp -R ./sugar /var/www/sugar' do
  cwd "#{Chef::Config[:file_cache_path]}"
  user 'root'
  group 'root'
  not_if do FileTest.directory?('/var/www/sugar') end
end

execute "set ownership of sugar to www.data" do
  command "chown -R www-data.www-data /var/www/sugar/"  
end

execute "restart apache" do
  user "root"
  command "service apache2 restart"  
end