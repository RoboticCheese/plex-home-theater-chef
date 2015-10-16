# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Resource:: plex_home_theater_service_windows
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

require 'net/http'
require_relative 'plex_home_theater_service'

class Chef
  class Resource
    # A custom resource for Plex Home Theater service actions for Windows.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PlexHomeTheaterServiceWindows < PlexHomeTheaterService
      provides :plex_home_theater_service, platform_family: 'windows'

      #
      # Use a windows_auto_run resource to auto-start Plex.
      #
      action :enable do
        windows_auto_run 'Plex Home Theater' do
          program ::File.join(PATH, 'Plex Home Theater.exe')
          action :create
        end
      end

      #
      # Use a windows_auto_run resource to remove Plex.
      #
      action :disable do
        windows_auto_run 'Plex Home Theater' do
          action :remove
        end
      end

      #
      # Use PowerShell's 'Start-Process' command to run Plex.
      #
      action :start do
        powershell_script 'start Plex Home Theater' do
          code "Start-Process \"#{PATH}/Plex Home Theater.exe\""
          action :run
          only_if do
            cmd = 'Get-Process \"Plex Home Theater\" -ErrorAction ' \
                  'SilentlyContinue'
            Mixlib::ShellOut.new("powershell -c \"#{cmd}\"").run_command
              .stdout.empty?
          end
        end
      end

      # TODO: action :stop do...
    end
  end
end
