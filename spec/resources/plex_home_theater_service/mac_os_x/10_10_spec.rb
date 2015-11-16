require_relative '../../../spec_helper'

describe 'resource_plex_home_theater_service::mac_os_x::10_10' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(step_into: 'plex_home_theater_service',
                             platform: 'mac_os_x',
                             version: '10.10')
  end
  let(:converge) do
    runner.converge("plex_home_theater_service_test::#{action}")
  end

  context 'the default action (:nothing)' do
    let(:action) { :default }
    cached(:chef_run) { converge }

    it 'does nothing with the service' do
      [
        'Enable Plex Home Theater',
        'Disable Plex Home Theater',
        'Start Plex Home Theater',
        'Stop Plex Home Theater'
      ].each do |e|
        expect(chef_run).to_not run_execute(e)
      end
    end
  end

  context 'the :enable action' do
    let(:action) { :enable }
    let(:enabled?) { nil }
    let(:shell_out) do
      double(run_command: double(stdout: enabled? ? 'stuff' : ''))
    end
    cached(:chef_run) { converge }

    before(:each) do
      cmd = 'osascript -e \'tell application "System Events" to get the ' \
            'name of the login item "Plex Home Theater"\''
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shell_out)
    end

    context 'not already enabled' do
      let(:enabled?) { false }

      it 'enables Plex Home Theater to start on login' do
        expected = 'osascript -e \'tell application "System Events" to make ' \
                   'new login item at end with properties {name: "Plex Home ' \
                   'Theater", path: "/Applications/Plex Home Theater.app", ' \
                   'hidden: false}\''
        expect(chef_run).to run_execute('Enable Plex Home Theater')
          .with(command: expected)
      end
    end

    context 'already enabled' do
      let(:enabled?) { true }
      cached(:chef_run) { converge }

      it 'does not try to enable Plex Home Theater again' do
        expect(chef_run).to_not run_execute('Enable Plex Home Theater')
      end
    end
  end

  context 'the :disable action' do
    let(:action) { :disable }
    let(:enabled?) { nil }
    let(:shell_out) do
      double(run_command: double(stdout: enabled? ? 'stuff' : ''))
    end

    before(:each) do
      cmd = 'osascript -e \'tell application "System Events" to get the ' \
            'name of the login item "Plex Home Theater"\''
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shell_out)
    end

    context 'already enabled' do
      let(:enabled?) { true }
      cached(:chef_run) { converge }

      it 'disables Plex Home Theater' do
        expected = 'osascript -e \'tell application "System Events" to ' \
                   'delete login item "Plex Home Theater"\''
        expect(chef_run).to run_execute('Disable Plex Home Theater')
          .with(command: expected)
      end
    end

    context 'not already enabled' do
      let(:enabled?) { false }
      cached(:chef_run) { converge }

      it 'does not try to disable Plex Home Theater again' do
        expect(chef_run).to_not run_execute('Disable Plex Home Theater')
      end
    end
  end

  context 'the :start action' do
    let(:action) { :start }
    let(:running?) { nil }
    let(:shell_out) do
      double(run_command: double(stdout: running? ? 'stuff' : ''))
    end

    before(:each) do
      cmd = 'ps -A -c -o command | grep ^Plex Home Theater$'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shell_out)
    end

    context 'not already running' do
      let(:running?) { false }
      cached(:chef_run) { converge }

      it 'starts Plex Home Theater' do
        expect(chef_run).to run_execute('Start Plex Home Theater')
          .with(command: 'open \'/Applications/Plex Home Theater.app\'',
                user: Etc.getlogin)
      end
    end

    context 'already running' do
      let(:running?) { true }
      cached(:chef_run) { converge }

      it 'does not start Plex Home Theater' do
        expect(chef_run).to_not run_execute('Start Plex Home Theater')
      end
    end
  end

  context 'the :stop action' do
    let(:action) { :stop }
    cached(:chef_run) { converge }

    it 'stops Plex Home Theater' do
      expect(chef_run).to run_execute('Stop Plex Home Theater')
        .with(command: 'killall Plex\\ Home\\ Theater',
              user: Etc.getlogin,
              ignore_failure: true)
    end
  end
end
