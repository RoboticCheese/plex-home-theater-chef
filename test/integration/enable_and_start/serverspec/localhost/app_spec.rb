# Encoding: UTF-8

require_relative '../spec_helper'

describe 'plex-home-theater::app' do
  describe file('/Applications/Plex Home Theater.app'),
           if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  describe command(
    'osascript -e \'tell application "System Events" to get the name of the ' \
    'login item "Plex Home Theater"\''
  ) do
    it 'indicates Plex Home Theater is enabled' do
      expect(subject.stdout.strip).to eq('Plex Home Theater')
    end
  end

  describe process('Plex Home Theater') do
    it 'is running' do
      expect(subject).to be_running
    end
  end
end
