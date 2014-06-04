include_recipe "apt"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "apache2"
include_recipe "apache2::mod_php5"

apt_package "install php extensions" do
  package_name "php5-mysql"
  action :install
end

apache_site "default" do
  enable true
end