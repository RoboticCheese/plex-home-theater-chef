# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Library:: provider_plex_home_theater_app_mac_os_x
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
require 'chef/provider/lwrp_base'
require_relative 'provider_plex_home_theater_app'

class Chef
  class Provider
    class PlexHomeTheaterApp < Provider::LWRPBase
      # An provider for Plex Home Theater for Mac OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < PlexHomeTheaterApp
        URL ||= 'https://plex.tv/downloads'
        PATH ||= '/Applications/Plex Home Theater.app'

        private

        #
        # Use a dmg_package resource to download and install the package. The
        # dmg_resource creates an inline remote_file, so this is all that's
        # needed.
        #
        # (see PlexHomeTheaterApp#install!)
        #
        def install!
          download_package
          install_package
        end

        #
        # Clear out the application directory itself plus the support and log
        # directories.
        #
        # (see PlexHomeTheaterApp#remove!)
        #
        def remove!
          delete_all_directories
          file ::File.expand_path('~/Library/Logs/Plex Home Theater.log') do
            action :delete
          end
        end

        #
        # Use an execute resource to extract the downloaded .zip file package.
        #
        def install_package
          path = download_path
          execute 'unzip Plex Home Theater app' do
            command "unzip -d /Applications #{path}"
            action :run
            creates PATH
          end
        end

        #
        # Use a remote_file resource to download the .zip file package.
        #
        def download_package
          s = remote_path
          remote_file download_path do
            source s
            action :create
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Use directory resources to clean up all of Plex Home Theater's
        # directories.
        #
        def delete_all_directories
          [
            PATH,
            ::File.expand_path('~/Library/Application Support/' \
                               'Plex Home Theater')
          ].each do |d|
            directory d do
              recursive true
              action :delete
            end
          end
        end

        #
        # Construct a local path to download the package file to.
        #
        # @return [String] a download path on the local filesystem
        #
        def download_path
          ::File.join(Chef::Config[:file_cache_path],
                      ::File.basename(remote_path))
        end

        #
        # Do a GET on the Plex download page and pull out the OS X download
        # link.
        #
        # @return [String] the URL of the OS X .zip package
        #
        def remote_path
          @remote_path ||= begin
            u = URI.parse(URL)
            opts = { use_ssl: u.scheme == 'https',
                     ca_file: Chef::Config[:ssl_ca_file] }
            body = Net::HTTP.start(u.host, u.port, opts) { |h| h.get(u) }.body
            regex = Regexp.new('https://downloads\.plex\.tv/' \
                               'plex-home-theater/.*/' \
                               'PlexHomeTheater.*-macosx-x86_64.zip')
            body.match(regex).to_s
          end
        end
      end
    end
  end
end
