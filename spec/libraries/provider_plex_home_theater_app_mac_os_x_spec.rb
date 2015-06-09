# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_plex_home_theater_app_mac_os_x'

describe Chef::Provider::PlexHomeTheaterApp::MacOsX do
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
      expected = '/Applications/Plex Home Theater.app'
      expect(described_class::PATH).to eq(expected)
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

  describe '#remove' do
    before(:each) do
      [:delete_all_directories, :file].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'deletes all the Plex directories' do
      p = provider
      expect(p).to receive(:delete_all_directories)
      p.send(:remove!)
    end

    it 'deletes the Plex log file' do
      p = provider
      expect(p).to receive(:file)
        .with(File.expand_path('~/Library/Logs/Plex Home Theater.log'))
        .and_yield
      expect(p).to receive(:action).with(:delete)
      p.send(:remove!)
    end
  end

  describe '#install_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/plex.zip')
    end

    it 'unzips the file into /Applications' do
      p = provider
      expect(p).to receive(:execute).with('unzip Plex Home Theater app')
        .and_yield
      expect(p).to receive(:command)
        .with('unzip -d /Applications /tmp/plex.zip')
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:creates)
        .with('/Applications/Plex Home Theater.app')
      p.send(:install_package)
    end
  end

  describe '#download_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('http://example.com/plex.zip')
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/plex.zip')
    end

    it 'downloads the remote .zip file' do
      p = provider
      expect(p).to receive(:remote_file).with('/tmp/plex.zip').and_yield
      expect(p).to receive(:source).with('http://example.com/plex.zip')
      expect(p).to receive(:action).with(:create)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?)
        .with('/Applications/Plex Home Theater.app')
      p.send(:download_package)
    end
  end

  describe '#delete_all_directories' do
    it 'deletes all the Plex directories' do
      p = provider
      [
        '/Applications/Plex Home Theater.app',
        File.expand_path('~/Library/Application Support/Plex Home Theater')
      ].each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.send(:delete_all_directories)
    end
  end

  describe '#download_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('http://example.com/plex.zip')
    end

    it 'returns a cache path' do
      expected = "#{Chef::Config[:file_cache_path]}/plex.zip"
      expect(provider.send(:download_path)).to eq(expected)
    end
  end

  describe '#remote_path' do
    let(:body) do
      '<html><p>SOME STUFF</p><p>https://downloads.plex.tv/plex-home-theater' \
        '/1.4.1.469-47a90f01/PlexHomeTheater-1.4.1.469-47a90f01-macosx-' \
        'x86_64.zip</p></html>'
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
                 '47a90f01/PlexHomeTheater-1.4.1.469-47a90f01-macosx-x86_64' \
                 '.zip'
      expect(provider.send(:remote_path)).to eq(expected)
    end
  end
end
