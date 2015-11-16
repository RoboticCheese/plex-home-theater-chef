require_relative '../../../spec_helper'

describe 'resource_plex_home_theater::mac_os_x::10_10' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'plex_home_theater',
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      node.set['plex_home_theater']['app']['source'] = source
    end
  end
  let(:converge) { runner.converge("plex_home_theater_test::#{action}") }

  context 'the default action (:create)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'creates Plex Home Theater' do
        expect(chef_run).to create_plex_home_theater('default')
      end

      it 'installs the Plex Home Theater app' do
        expect(chef_run).to install_plex_home_theater_app('default')
          .with(source: source)
      end

      it 'does nothing with the Plex Home Theater service' do
        expect(chef_run.plex_home_theater_service('default')).to do_nothing
      end
    end

    context 'no source attribute' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'a source attribute' do
      let(:source) { 'http://example.com/plex.zip' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'stops the Plex Home Theater service' do
      expect(chef_run).to stop_plex_home_theater_service('default')
    end

    it 'disables the Plex Home Theater service' do
      expect(chef_run).to disable_plex_home_theater_service('default')
    end
  end
end
