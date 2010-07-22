#
# Cookbook Name:: rentages
# Recipe:: default
#
# Copyright 2010, SamLown.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "language-pack-en"
package "build-essential"

include_recipe "mongodb"
include_recipe "ityzen"

nginx_unicorn_web_app 'rentages' do
  user 'rentages'
  domains ['srv1.rentages.com']
end


