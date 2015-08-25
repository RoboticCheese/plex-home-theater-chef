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

  describe command(
    'Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"'
  ), if: os[:family] == 'windows' do
    it 'indicates Plex Home Theater is enabled' do
      expect(subject.stdout).to match(/^Plex Home Theater/)
    end
  end

  # TODO: Using process('Plex Home Theater') requires a fix for Specinfra to
  # not try to use `ps -C` in OS X.
  describe command(
    'ps -A -c -o command | grep Plex\ Home\ Theater'
  ), if: os[:family] == 'darwin' do
    it 'is running' do
      expect(subject.stdout.strip).to eq('Plex Home Theater')
    end
  end

  describe command('(Get-Process "Plex Home Theater") -ne $null'),
           if: os[:family] == 'windows' do
    it 'indicates Plex is running' do
      expect(subject.stdout.strip).to eq('True')
    end
  end
end
