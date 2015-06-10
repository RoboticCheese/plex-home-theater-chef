# Encoding: UTF-8

include_recipe 'plex-home-theater'

plex_home_theater_app 'default' do
  action [:enable, :start]
end
