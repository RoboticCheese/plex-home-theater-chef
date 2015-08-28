# Encoding: UTF-8

require_relative '../spec_helper'

describe 'plex-home-theater::app' do
  describe file('/Applications/Plex Home Theater.app'),
           if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  describe package('Plex Home Theater'), if: os[:family] == 'windows' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe command(
    'osascript -e \'tell application "System Events" to get the name of the ' \
    'login item "Plex Home Theater"\''
  ), if: os[:family] == 'darwin' do
    it 'indicates Plex Home Theater is enabled' do
      expect(subject.stdout.strip).to eq('Plex Home Theater')
    end
  end

  describe windows_registry_key(
    'HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run'
  ), if: os[:family] == 'windows' do
    it 'indicates Plex Home Theater is enabled' do
      expect(subject).to have_property('Plex Home Theater')
    end
  end

  describe process('Plex Home Theater'), if: os[:family] == 'darwin' do
    it 'is running' do
      expect(subject).to be_running
    end
  end

  describe command('(Get-Process "Plex Home Theater") -ne $null'),
           if: os[:family] == 'windows' do
    it 'indicates Plex is running' do
      expect(subject.stdout.strip).to eq('True')
    end
  end
end
