# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Library:: resource_plex_home_theater
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
require_relative 'resource_plex_home_theater_app'
require_relative 'resource_plex_home_theater_service'

class Chef
  class Resource
    # A custom resource that wraps each Plex Home Theater subresource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PlexHomeTheater < Resource
      provides :plex_home_theater

      property :source, [String, nil], default: nil

      default_action :create

      action :create do
        plex_home_theater_app(name) { source new_resource.source }
        plex_home_theater_service name
      end

      action :remove do
        plex_home_theater_service(name) { action [:stop, :disable] }
        plex_home_theater_app(name) { action :remove }
      end
    end
  end
end
