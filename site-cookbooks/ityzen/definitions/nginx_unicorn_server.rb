#
# Definition for the Rails Web App
#

define :nginx_unicorn_web_app, :user => 'user', :domains => ['www.site.com']  do

  include_recipe "nginx"
  include_recipe "unicorn"
  include_recipe "god"

  app_params = params
  app_path = File.join("/home", params[:user], "deploy", params[:name])

  group params[:user]

  user params[:user] do
    comment app_params[:user]
    gid app_params[:user]
    home "/home/" + app_params[:user]
    shell '/bin/bash'
  end

  directory app_path do
    owner app_params[:user]
    group app_params[:user]
    mode "0755"
    action :create
    recursive true
  end

  template "/etc/nginx/sites-available/#{params[:name]}" do
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    source "nginx-site.erb"
    mode "0755"
    owner "root"
    group "root"
    variables({
      :socket => File.join(app_path, 'shared', 'sockets', 'unicorn.sock'),
      :root => File.join(app_path, 'current', 'public'),
      :domains => app_params[:domains],
      :params => app_params,
      :app_name => params[:name] + '_app'
    })
  end

  nginx_site "default" do
    enable false
  end
  nginx_site params[:name]

  template File.join('/etc/logrotate.d', app_params[:name]) do
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    source 'unicorn_logrotate.erb'
    owner 'root'
    group 'root'
    mode 0644
    #notifies :restart, resources(:service => 'logrotate')
    variables({
      :path => app_path,
      :user => app_params[:user],
      :group => app_params[:user],
    })
  end


  god_monitor params[:name] do
    config "unicorn.god.erb"
    max_memory 150
    rails_root File.join(app_path, "current")
    user app_params[:user]
    group app_params[:user]
  end

end
