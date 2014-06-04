include_recipe "ark"
include_recipe "database::mysql"

bash "download and extract MediaWiki" do
     user "vagrant"
     cwd "/var/chef/cache"
     code <<-EOH
       wget http://releases.wikimedia.org/mediawiki/1.22/mediawiki-1.22.7.tar.gz
       tar -zxvf mediawiki-1.22.7.tar.gz
       mv ./mediawiki-1.22.7 ./mediawiki
     EOH
     not_if "test -d /var/chef/cache/mediawiki"
end

execute 'cp -R ./mediawiki /var/www/mediawiki' do
  cwd "#{Chef::Config[:file_cache_path]}"
  user 'root'
  group 'root'
  not_if do FileTest.directory?('/var/www/mediawiki') end
end

execute "set ownership of mediawiki to www.data" do
  command "chown -R www-data.www-data /var/www/mediawiki/"  
end

execute "restart apache" do
  user "root"
  command "service apache2 restart"  
end