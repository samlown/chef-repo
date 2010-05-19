
include_recipe "planetaki"

# Specific requirements for the server environment

include_recipe "nginx"
include_recipe "unicorn"
include_recipe "god"

package "git-core"

group "planetaki"

user "planetaki" do
  comment "Planetaki User"
  gid "planetaki"
  home "/home/planetaki"
  shell "/bin/sh"
end

directory "/home/planetaki" do
  owner "planetaki"
  group "planetaki"
  mode "0755"
  action :create
end

template "/etc/nginx/sites-available/planetaki" do
  source "planetaki-site.erb"
  mode "0755"
  owner "root"
  group "root"
end

nginx_site "default" do
  enable false 
end

nginx_site "planetaki"

god_monitor "planetaki" do
  config "unicorn.god.erb"
  max_memory 150
  rails_root "/home/planetaki/deploy/Planetaki/current"
end


