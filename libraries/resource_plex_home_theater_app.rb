# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Library:: plex_home_theater_app
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
    # A parent custom resource for Plex Home Theater App.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PlexHomeTheaterApp < Resource
      property :source, [String, nil], default: nil

      default_action :install

      %i(install remove).each do |a|
        action a do
          raise(
            NotImplementedError,
            "Action '#{a}' must be implemented for '#{self.class}' resource"
          )
        end
      end
    end
  end
end
