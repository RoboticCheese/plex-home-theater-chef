require_relative '../../../spec_helper'

describe 'resource_plex_home_theater_app::mac_os_x::10_10' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'plex_home_theater_app',
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      node.set['plex_home_theater']['app']['source'] = source
    end
  end
  let(:chef_run) { runner.converge("plex_home_theater_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }
    let(:installed?) { nil }

    before(:each) do
      {
        download_path: '/tmp/plex.zip',
        source_path: 'http://example.com/plex.zip'
      }.each do |k, v|
        allow_any_instance_of(Chef::Resource::PlexHomeTheaterAppMacOsX)
          .to receive(k).and_return(v)
      end
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with('/Applications/Plex Home Theater.app').and_return(installed?)
    end

    shared_examples_for 'any attribute set' do
      it 'extracts and installs the package file' do
        expect(chef_run).to run_execute('unzip -d /Applications /tmp/plex.zip')
          .with(creates: '/Applications/Plex Home Theater.app')
      end
    end

    shared_examples_for 'app not already installed' do
      it 'downloads the package file' do
        expect(chef_run).to create_remote_file('/tmp/plex.zip').with(
          source: source || 'http://example.com/plex.zip'
        )
      end
    end

    context 'no source attribute' do
      let(:source) { nil }
      let(:installed?) { false }

      it_behaves_like 'any attribute set'
      it_behaves_like 'app not already installed'
    end

    context 'a source attribute' do
      let(:source) { 'http://example.com/plex.dmg' }
      let(:installed?) { false }

      it_behaves_like 'any attribute set'
      it_behaves_like 'app not already installed'
    end

    context 'app already installed' do
      let(:source) { nil }
      let(:installed?) { true }

      it_behaves_like 'any attribute set'

      it 'does not download the package file' do
        expect(chef_run).to_not create_remote_file('/tmp/plex.zip')
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }

    it 'deletes the main application dir' do
      d = '/Applications/Plex Home Theater.app'
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end

    it 'deletes the application support dir' do
      d = File.expand_path('~/Library/Application Support/Plex Home Theater')
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end

    it 'deletes the log file' do
      f = File.expand_path('~/Library/Logs/Plex Home Theater.log')
      expect(chef_run).to delete_file(f)
    end
  end
end
