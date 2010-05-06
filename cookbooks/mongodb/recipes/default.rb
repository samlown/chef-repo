
# Cookbook Name:: mongodb 
# Recipe:: default
#
# Meant for vagrant installs

package "curl"

package_tgz = case `uname -m`
when /x86_64/
  'mongodb-linux-x86_64-1.4.1.tgz'  # 64 bit
else
  'mongodb-linux-i686-1.4.1.tgz' # 32 bit 
end
package_folder = package_tgz.gsub('.tgz', '')

group "mongodb"
user "mongodb" do
  comment "MongoDB User"
  gid "mongodb"
end

directory "/data/docs/mongodb" do
  owner "mongodb"
  group "mongodb"
  mode 0755
  recursive true
end

directory "/var/log/mongodb" do
  owner "mongodb"
  group "mongodb"
  mode 0755
  recursive true
end

execute "install-mongodb" do
  command %Q{
    curl -O http://downloads.mongodb.org/linux/#{package_tgz} &&
    tar zxvf #{package_tgz} &&
    mv #{package_folder} /usr/local/mongodb &&
    rm #{package_tgz}
  }
  not_if { File.directory?('/usr/local/mongodb') }
end
execute "add-to-path" do
  command %Q{
    echo 'export PATH=$PATH:/usr/local/mongodb/bin' >> /etc/profile
  }
  not_if "grep 'export PATH=$PATH:/usr/local/mongodb/bin' /etc/profile"
end

remote_file "/etc/init.d/mongodb" do
  source "mongodb"
  owner "root"
  group "root"
  mode 0755
end

service "mongodb" do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end

