# Encoding: UTF-8
#
# Cookbook Name:: plex-home-theater
# Library:: matchers
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

if defined?(ChefSpec)
  %w(
    plex_home_theater plex_home_theater_app plex_home_theater_service
  ).each do |matcher|
    ChefSpec.define_matcher(matcher)
  end

  {
    plex_home_theater: %i(nothing create remove),
    plex_home_theater_app: %i(nothing install remove),
    plex_home_theater_service: %i(nothing enable disable start stop)
  }.each do |resource, actions|
    actions.each do |action|
      define_method("#{action}_#{resource}") do |name|
        ChefSpec::Matchers::ResourceMatcher.new(resource, action, name)
      end
    end
  end
end
