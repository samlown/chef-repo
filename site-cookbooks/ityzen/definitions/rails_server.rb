#
# Definition for the Rails Web App
#

define :rails_web_app, :user => 'user', :domains => ['www.site.com'], :rails_version => "2.3.8", :template => 'passenger_web_app.conf.erb' do

  include_recipe "apache2"
  include_recipe "capistrano"
  include_recipe "passenger_apache2"

  app_params = params

  gem_package "pg"
  gem_package "haml"
  gem_package "gemcutter"

  # The basic packages required
  gem_package "rails" do
    version params[:rails_version]
  end

  user params[:user] do
    comment app_params[:user]
    home "/home/" + app_params[:user]
    shell '/bin/bash'
  end

  directory File.join("/home", params[:user], "deploy", params[:name]) do
    owner app_params[:user]
    group app_params[:user]
    mode "0755"
    action :create
    recursive true
  end

  cap_setup params[:name] do
    path File.join("/home", app_params[:user], "deploy", app_params[:name])
    owner app_params[:user]
    group app_params[:user]
    appowner app_params[:user]
  end

  web_app params[:name] do
    server_name app_params[:domains].shift
    server_aliases app_params[:domains]
    docroot File.join("/home", app_params[:user], "deploy", app_params[:name], "current", "public")
    rails_env "production"
    template app_params[:template]
  end

  template File.join('/etc/logrotate.d', app_params[:name]) do
    source 'rails_logrotate.erb'
    owner 'root'
    group 'root'
    mode 0644
    #notifies :restart, resources(:service => 'logrotate')
    variables({
      :path => File.join("/home", app_params[:user], "deploy", app_params[:name]),
      :user => app_params[:user],
      :group => app_params[:user],
    })
  end

end
