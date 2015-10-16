# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Resource:: plex_home_theater_service_mac_os_x
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

require 'mixlib/shell_out'
require_relative 'plex_home_theater_service'

class Chef
  class Resource
    # An implementation of Plex Home Theater service actions for Mac OS X.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PlexHomeTheaterServiceMacOsX < PlexHomeTheaterService
      provides :plex_home_theater_service, platform_family: 'mac_os_x'

      #
      # Use AppleScript to fire off a system event to create an OS X login
      # item for Plex Home Theater.
      #
      # TODO: This should eventually take the form of applescript and
      # login_item resources in the mac_os_x cookbook.
      #
      action :enable do
        cmd = "osascript -e 'tell application \"System Events\" to make " \
              'new login item at end with properties ' \
              "{name: \"Plex Home Theater\", path: \"#{PATH}\", " \
              "hidden: false}'"
        execute 'enable Plex Home Theater' do
          command cmd
          action :run
          only_if { !enabled? }
        end
      end

      #
      # Use AppleScript to remove the Plex Home Theater login item.
      #
      action :disable do
        cmd = 'osascript -e \'tell application "System Events" to delete ' \
              'login item "Plex Home Theater"\''
        execute 'disable Plex Home Theater' do
          command cmd
          action :run
          only_if { enabled? }
        end
      end

      #
      # Use the `open` command to start up Plex Home Theater.
      #
      action :start do
        execute 'start Plex Home Theater' do
          command "open '#{PATH}'"
          user Etc.getlogin
          action :run
          only_if do
            cmd = 'ps -A -c -o command | grep ^Plex Home Theater$'
            Mixlib::ShellOut.new(cmd).run_command.stdout.empty?
          end
        end
      end

      private

      #
      # Shell out and use AppleScript to check whether the login item
      # already exists.
      #
      # @return [TrueClass, FalseClass]
      #
      def enabled?
        cmd = "osascript -e 'tell application \"System Events\" to get the " \
              "name of the login item \"Plex Home Theater\"'"
        !Mixlib::ShellOut.new(cmd).run_command.stdout.empty?
      end
    end
  end
end
