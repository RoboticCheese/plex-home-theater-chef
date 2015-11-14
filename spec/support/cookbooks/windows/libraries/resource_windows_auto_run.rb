# Encoding: UTF-8

require 'chef/resource'

class Chef
  class Resource
    # A stub of the windows_auto_run resource
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class WindowsAutoRun < Resource
      property :program, String
      action(:create) {}
      action(:remove) {}
    end
  end
end
