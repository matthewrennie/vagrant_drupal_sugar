include_recipe "apt"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "apache2"
include_recipe "apache2::mod_php5"

apache_site "default" do
  enable true
end
