
package "language-pack-en"

package "build-essential"

include_recipe "imagemagick"
include_recipe "rabbitmq"
include_recipe "mongodb"
include_recipe "rails"
include_recipe "postgresql"

include_recipe "postgresql::server"

#web_app "planetaki" do
#  docroot "/vagrant/public"
#  server_name "localhost"
#  rails_env "development"
#end

package "rake"
package "irb"

# For nokogiri
package "libxml2-dev"
package "libxslt1-dev"

# For Databases
package "libsqlite3-ruby"
package "libpgsql-ruby"

# For feedzirra
package "libcurl4-openssl-dev"

# Gem packages required
[
  ["fast_gettext", "0.5.3"],
  "haml", "json", "nokogiri", "feedzirra", "jnunemaker-validatable",
  "mongo_mapper", "mini_magick", "carrierwave", 
  "bunny", "amqp", "loofah", "daemons",
  "bson_ext", "ruby-openid", "memcache",
  "workling", "gettext", "rspec", "mongrel", "aws"
].each do |lib|

  if lib.is_a?(Array)
    gem_package lib[0] do
      version lib[1]
      action :install
    end
  else
    gem_package lib do
      action :install
    end
  end
end

