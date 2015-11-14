# Encoding: UTF-8

if defined?(ChefSpec)
  ChefSpec.define_matcher(:windows_auto_run)

  %i(create remove).each do |action|
    define_method("#{action}_windows_auto_run") do |name|
      ChefSpec::Matchers::ResourceMatcher.new(:windows_auto_run,
                                              action,
                                              name)
    end
  end
end
