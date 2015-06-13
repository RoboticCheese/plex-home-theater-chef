# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_plex_home_theater_app_windows'

describe Chef::Provider::PlexHomeTheaterApp::Windows do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::PlexHomeTheaterApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'URL' do
    it 'returns the download page URL' do
      expected = 'https://plex.tv/downloads'
      expect(described_class::URL).to eq(expected)
    end
  end

  describe 'PATH' do
    it 'returns the app directory' do
      expected = File.expand_path('/Program Files (x86)/Plex Home Theater')
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '#enable!' do
    it 'uses a windows_auto_run resource to enable Plex' do
      p = provider
      expect(p).to receive(:windows_auto_run).with('Plex Home Theater')
        .and_yield
      expect(p).to receive(:program)
        .with("#{described_class::PATH}/Plex Home Theater.exe")
      expect(p).to receive(:action).with(:create)
      p.send(:enable!)
    end
  end

  describe '#disable!' do
    it 'uses a windows_auto_run resource to disable Plex' do
      p = provider
      expect(p).to receive(:windows_auto_run).with('Plex Home Theater')
        .and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:disable!)
    end
  end

  describe '#start!' do
    it 'uses a powershell_script to start the app' do
      p = provider
      expect(p).to receive(:powershell_script).with('start Plex Home Theater')
        .and_yield
      cmd = "Start-Process \"#{described_class::PATH}/Plex Home Theater.exe\""
      expect(p).to receive(:code).with(cmd)
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:only_if).and_yield
      cmd = 'powershell -c "Get-Process \"Plex Home Theater\" -ErrorAction ' \
            'SilentlyContinue"'
      expect(Mixlib::ShellOut).to receive(:new).with(cmd)
        .and_return(double(run_command: double(stdout: 'test')))
      p.send(:start!)
    end
  end

  describe '#install!' do
    before(:each) do
      [:download_package, :install_package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'downloads the package' do
      expect_any_instance_of(described_class).to receive(:download_package)
      provider.send(:install!)
    end

    it 'installs the package' do
      expect_any_instance_of(described_class).to receive(:install_package)
      provider.send(:install!)
    end
  end

  describe '#remove!' do
    it 'uses a windows_package resource to uninstall Plex' do
      p = provider
      expect(p).to receive(:windows_package).with('Plex Home Theater')
        .and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end

  describe '#install_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/plex.exe')
    end

    it 'uses a windows_package resource to install' do
      p = provider
      expect(p).to receive(:windows_package).with('Plex Home Theater')
        .and_yield
      expect(p).to receive(:source).with('/tmp/plex.exe')
      expect(p).to receive(:installer_type).with(:nsis)
      expect(p).to receive(:action).with(:install)
      p.send(:install_package)
    end
  end

  describe '#download_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('http://example.com/plex.exe')
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/plex.exe')
    end

    it 'downloads the remote .exe file' do
      p = provider
      expect(p).to receive(:remote_file).with('/tmp/plex.exe').and_yield
      expect(p).to receive(:source).with('http://example.com/plex.exe')
      expect(p).to receive(:action).with(:create)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?)
        .with(File.expand_path('/Program Files (x86)/Plex Home Theater'))
      p.send(:download_package)
    end
  end

  describe '#download_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('http://example.com/plex.exe')
    end

    it 'returns a cache path' do
      expected = "#{Chef::Config[:file_cache_path]}/plex.exe"
      expect(provider.send(:download_path)).to eq(expected)
    end
  end

  describe '#remote_path' do
    let(:body) do
      '<html><p>SOME STUFF</p><p>https://downloads.plex.tv/plex-home-theater' \
        '/1.4.1.469-47a90f01/PlexHomeTheater-1.4.1.469-47a90f01-windows-x86' \
        '.exe</p></html>'
    end
    let(:start) { double(body: body) }

    before(:each) do
      allow(Net::HTTP).to receive(:start).and_return(start)
    end

    it 'passes in the correct HTTP options' do
      expect(Net::HTTP).to receive(:start).with(
        'plex.tv', 443, use_ssl: true, ca_file: Chef::Config[:ssl_ca_file]
      ).and_return(start)
      provider.send(:remote_path)
    end

    it 'returns the .zip file URL' do
      expected = 'https://downloads.plex.tv/plex-home-theater/1.4.1.469-' \
                 '47a90f01/PlexHomeTheater-1.4.1.469-47a90f01-windows-x86.exe'
      expect(provider.send(:remote_path)).to eq(expected)
    end
  end
end
