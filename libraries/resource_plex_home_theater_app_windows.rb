# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Library:: plex_home_theater_app_windows
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
require_relative 'resource_plex_home_theater_app'

class Chef
  class Resource
    # A custom resource for Plex Home Theater for Windows.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PlexHomeTheaterAppWindows < PlexHomeTheaterApp
      URL ||= 'https://plex.tv/downloads'
      PATH ||= ::File.expand_path('/Program Files (x86)/Plex Home Theater')

      provides :plex_home_theater_app, platform_family: 'windows'

      #
      # Download the app from the remote server and then install it.
      #
      # (see PlexHomeTheaterApp#install!)
      #
      action :install do
        remote_file download_path do
          source source_path
          action :create
          only_if { !::File.exist?(PATH) }
        end
        windows_package 'Plex Home Theater' do
          source download_path
          installer_type :nsis
          action :install
        end
      end

      #
      # Use a windows_package resource to remove the app.
      #
      action :remove do
        windows_package 'Plex Home Theater' do
          action :remove
        end
      end

      #
      # Construct a local path to download the package file to.
      #
      # @return [String] a download path on the local filesystem
      #
      def download_path
        ::File.join(Chef::Config[:file_cache_path],
                    ::File.basename(source_path))
      end

      #
      # Do a GET on the Plex download page and pull out the OS X download
      # link.
      #
      # @return [String] the URL of the OS X .zip package
      #
      def source_path
        @source_path ||= source || begin
          u = URI.parse(URL)
          opts = { use_ssl: u.scheme == 'https',
                   ca_file: Chef::Config[:ssl_ca_file] }
          body = Net::HTTP.start(u.host, u.port, opts) { |h| h.get(u) }.body
          regex = Regexp.new('https://downloads\.plex\.tv/' \
                             'plex-home-theater/.*/' \
                             'PlexHomeTheater.*-windows-x86.exe')
          body.match(regex).to_s
        end
      end
    end
  end
end
