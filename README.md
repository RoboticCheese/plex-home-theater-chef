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

This cookbook now uses the custom resource design pattern only available in
Chef 12.5 and up. It currently requires either OS X or Windows.

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

A platform-agnostic way to install or remove the Plex Home Theater app.

Syntax:

    plex_home_theater_app 'default' do
      source 'https://example.com/plex.package'
      action :install
    end

Actions:

| Action     | Description                       |
|------------|-----------------------------------|
| `:install` | Install the app                   |
| `:remove`  | Uninstall the app                 |

Attributes:

| Attribute | Default    | Description                         |
|-----------|------------|-------------------------------------|
| source    | `nil`      | An optional package source URL/path |
| action    | `:install` | Action(s) to perform                |

***plex_home_theater_app_mac_os_x***

OS X implementation of the `plex_home_theater_app` resource.

***plex_home_theater_app_windows***

Windows implementation of the `plex_home_theater_app` resource.

***plex_home_theater_service***

A platform-agnostic way to run Plex or set it to auto-run at login time.

Syntax:

    plex_home_theater_service 'default' do
      action :nothing
    end

Actions:

| Action     | Description                       |
|------------|-----------------------------------|
| `:enable`  | Set the app to start on login     |
| `:disable` | Set the app to not start on login |
| `:start`   | Start the app                     |
| `:stop`    | Stop the app\*                    |

_\* Currently not supported on Windows platforms_

Attributes:

| Attribute  | Default    | Description          |
|------------|------------|----------------------|
| action     | `:nothing` | Action(s) to perform |

***plex_home_theater_service_mac_os_x***

OS X implementation of the `plex_home_theater_service` resource.

***plex_home_theater_service_windows***

Windows implementation of the `plex_home_theater_service` resource.

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
