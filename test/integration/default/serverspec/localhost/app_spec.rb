# Encoding: UTF-8

require_relative '../spec_helper'

describe 'plex-home-theater::app' do
  describe file('/Applications/Plex Home Theater.app'),
           if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end
end
