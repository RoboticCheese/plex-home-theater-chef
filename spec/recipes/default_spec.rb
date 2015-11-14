# Encoding: UTF-8

require_relative '../spec_helper'

describe 'plex-home-theater::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs Plex Home Theater' do
    expect(chef_run).to create_plex_home_theater('default')
  end
end
