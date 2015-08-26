Plex Home Theater Cookbook
==========================
[![Cookbook Version](https://img.shields.io/cookbook/v/plex-home-theater.svg)][cookbook]
[![OS X Build Status](https://img.shields.io/travis/RoboticCheese/plex-home-theater-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/plex-home-theater-chef.svg)][appveyor]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/plex-home-theater-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/plex-home-theater-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/plex-home-theater
[travis]: https://travis-ci.org/RoboticCheese/plex-home-theater-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/plex-home-theater-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/plex-home-theater-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/plex-home-theater-chef

A Chef cookbook for installing Plex Home Theater.

Requirements
============

This cookbook currently requires either OS X or Windows.

Usage
=====

Either add the default recipe to your run_list or implement the resource
directly in a recipe of your own.

Recipes
=======

***default***

Installs Plex Home Theater.


Resources
=========

***plex_home_theater_app***

Used to install or remove the Plex Home Theater app.

Syntax:

    plex_home_theater_app 'default' do
        action :install
    end

Actions:

| Action     | Description                       |
|------------|-----------------------------------|
| `:install` | Install the app                   |
| `:remove`  | Uninstall the app                 |
| `:enable`  | Set the app to start on login     |
| `:disable` | Set the app to not start on login |
| `:start`   | Start the app                     |

Attributes:

| Attribute  | Default    | Description          |
|------------|------------|----------------------|
| action     | `:install` | Action(s) to perform |

Providers
=========

***Chef::Provider::PlexHomeTheaterApp::MacOsX***

Provider for Mac OS X platforms.

***Chef::Provider::PlexHomeTheaterApp::Windows***

Provider for Windows platforms.

***Chef::Provider::PlexHomeTheaterApp***

A parent provider for all the platform-specific providers to subclass.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
