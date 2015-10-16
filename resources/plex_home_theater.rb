# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Resource:: plex_home_theater
#
# Copyright 2015 Jonathan Hartman
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

require 'chef/resource'

class Chef
  class Resource
    # A custom resource that wraps each Plex Home Theater subresource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PlexHomeTheaterApp < Resource
      property :source, [String, nil], default: nil

      default_action :create

      action :create do
        plex_home_theater_app(name) { source source }
        plex_home_theater_service name
      end

      action :remove do
        plex_home_theater_service(name) { action [:stop, :disable] }
        plex_home_theater_app(name) { action :remove }
      end
    end
  end
end
