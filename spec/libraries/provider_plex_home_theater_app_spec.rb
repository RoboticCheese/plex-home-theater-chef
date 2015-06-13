# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_plex_home_theater_app'

describe Chef::Provider::PlexHomeTheaterApp do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::PlexHomeTheaterApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_enable' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:enable!)
    end

    it 'calls the child `enable!` method ' do
      expect_any_instance_of(described_class).to receive(:enable!)
      provider.action_enable
    end

    it 'sets the resource enabled status' do
      p = provider
      p.action_enable
      expect(p.new_resource.enabled?).to eq(true)
    end
  end

  describe '#action_disable' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:disable!)
    end

    it 'calls the child `disable!` method ' do
      expect_any_instance_of(described_class).to receive(:disable!)
      provider.action_disable
    end

    it 'sets the resource enabled status' do
      p = provider
      p.action_disable
      expect(p.new_resource.enabled?).to eq(false)
    end
  end

  describe '#action_start' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:start!)
    end

    it 'calls the child `start!` method ' do
      expect_any_instance_of(described_class).to receive(:start!)
      provider.action_start
    end

    it 'sets the resource running status' do
      p = provider
      p.action_start
      expect(p.new_resource.running?).to eq(true)
    end
  end

  describe '#action_install' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:install!)
    end

    it 'calls the child `install!` method ' do
      expect_any_instance_of(described_class).to receive(:install!)
      provider.action_install
    end

    it 'sets the resource installed status' do
      p = provider
      p.action_install
      expect(p.new_resource.installed?).to eq(true)
    end
  end

  describe '#action_remove' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remove!)
    end

    it 'calls the child `remove!` method ' do
      expect_any_instance_of(described_class).to receive(:remove!)
      provider.action_remove
    end

    it 'sets the resource installed status' do
      p = provider
      p.action_remove
      expect(p.new_resource.installed?).to eq(false)
    end
  end

  [:install!, :remove!, :start!, :enable!, :disable!].each do |a|
    describe "##{a}" do
      it 'raises an error' do
        expect { provider.send(a) }.to raise_error(NotImplementedError)
      end
    end
  end
end
