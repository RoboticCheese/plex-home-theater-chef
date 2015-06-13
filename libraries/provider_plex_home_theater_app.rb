# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Library:: provider_plex_home_theater_app
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

require 'chef/provider/lwrp_base'
require_relative 'resource_plex_home_theater_app'
require_relative 'provider_plex_home_theater_app_mac_os_x'
require_relative 'provider_plex_home_theater_app_windows'

class Chef
  class Provider
    # A parent Chef provider for the Plex Home Theater app.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class PlexHomeTheaterApp < Provider::LWRPBase
      use_inline_resources

      #
      # WhyRun is supported by this provider.
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Enable the app if it's not already and set its enabled status to true.
      #
      action :enable do
        enable!
        new_resource.enabled(true)
      end

      #
      # Disable the app if it's not already and set its enabled status to
      # false.
      #
      action :disable do
        disable!
        new_resource.enabled(false)
      end

      #
      # Start the app if it's not already running and set its running status
      # to true.
      #
      action :start do
        start!
        new_resource.running(true)
      end

      #
      # Install the app if it's not already and set the new_resource installed
      # status to true.
      #
      action :install do
        install!
        new_resource.installed(true)
      end

      #
      # Remove the app if it's installed and set the new_resource installed
      # status to false.
      #
      action :remove do
        remove!
        new_resource.installed(false)
      end

      private

      #
      # Do the actual app enabling.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def enable!
        fail(NotImplementedError,
             "`enable!` method not implemented for #{self.class} provider")
      end

      #
      # Do the actual app disabling.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def disable!
        fail(NotImplementedError,
             "`disable!` method not implemented for #{self.class} provider")
      end

      #
      # Do the actual app starting.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def start!
        fail(NotImplementedError,
             "`start!` method not implemented for #{self.class} provider")
      end

      #
      # Do the actual app installation.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def install!
        fail(NotImplementedError,
             "`install!` method not implemented for #{self.class} provider")
      end

      #
      # Do the actual app removal.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def remove!
        fail(NotImplementedError,
             "`remove!` method not implemented for #{self.class} provider")
      end
    end
  end
end
