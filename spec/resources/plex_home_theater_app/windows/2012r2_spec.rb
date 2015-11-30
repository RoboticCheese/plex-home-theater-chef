require_relative '../../../spec_helper'

describe 'resource_plex_home_theater_app::windows::2012r2' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'plex_home_theater_app',
      platform: 'windows',
      version: '2012R2'
    ) do |node|
      node.set['plex_home_theater']['app']['source'] = source
    end
  end
  let(:converge) { runner.converge("plex_home_theater_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }
    let(:body) do
      'https://downloads.plex.tv/plex-home-theater/4/' \
        'PlexHomeTheater.4-windows-x86.exe'
    end
    let(:installed?) { nil }

    before(:each) do
      allow(Net::HTTP).to receive(:start).and_return(double(body: body))
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with(File.expand_path('/Program Files (x86)/Plex Home Theater'))
        .and_return(installed?)
    end

    shared_examples_for 'any attribute set' do
      it 'installs the package file' do
        expect(chef_run).to install_windows_package('Plex Home Theater').with(
          source: "#{Chef::Config[:file_cache_path]}/" <<
                  (source ? File.basename(source) : File.basename(body)),
          installer_type: :nsis)
      end
    end

    shared_examples_for 'app not already installed' do
      it 'downloads the package file' do
        expect(chef_run).to create_remote_file(
          "#{Chef::Config[:file_cache_path]}/" <<
          (source ? File.basename(source) : File.basename(body))
        ).with(source: source || body)
      end
    end

    context 'no source attribute' do
      let(:source) { nil }
      let(:installed?) { false }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
      it_behaves_like 'app not already installed'
    end

    context 'a source attribute' do
      let(:source) { 'http://example.com/plex.exe' }
      let(:installed?) { false }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
      it_behaves_like 'app not already installed'
    end

    context 'app already installed' do
      let(:source) { nil }
      let(:installed?) { true }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'does not download the package file' do
        expect(chef_run).to_not create_remote_file(
          "#{Chef::Config[:file_cache_path]}/PlexHomeTheater.4-windows-x86.exe"
        )
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the package' do
      expect(chef_run).to remove_windows_package('Plex Home Theater')
    end
  end
end
