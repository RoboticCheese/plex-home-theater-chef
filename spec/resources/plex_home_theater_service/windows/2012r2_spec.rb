require_relative '../../../spec_helper'

describe 'resource_plex_home_theater_service::windows::2012r2' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'plex_home_theater_service',
      platform: 'windows',
      version: '2012R2'
    )
  end
  let(:chef_run) do
    runner.converge("plex_home_theater_service_test::#{action}")
  end

  context 'the default action (:nothing)' do
    let(:action) { :default }

    it 'does nothing' do
      expect(chef_run).to_not create_windows_auto_run('Plex Home Theater')
      expect(chef_run).to_not remove_windows_auto_run('Plex Home Theater')
      expect(chef_run).to_not run_powershell_script('Start Plex Home Theater')
    end
  end

  context 'the :enable action' do
    let(:action) { :enable }

    it 'creates an auto-run item for Plex Home Theater' do
      path = File.expand_path('/Program Files (x86)/Plex Home Theater/' \
                              'Plex Home Theater.exe')
      expect(chef_run).to create_windows_auto_run('Plex Home Theater')
        .with(program: path)
    end
  end

  context 'the :disable action' do
    let(:action) { :disable }

    it 'deletes the auto-run item for Plex Home Theater' do
      expect(chef_run).to remove_windows_auto_run('Plex Home Theater')
    end
  end

  context 'the :start action' do
    let(:action) { :start }
    let(:running?) { nil }
    let(:shell_out) do
      double(run_command: double(stdout: running? ? 'stuff' : ''))
    end

    before(:each) do
      cmd = 'powershell -c "Get-Process \\"Plex Home Theater\\" -ErrorAction ' \
            'SilentlyContinue"'
      allow(Mixlib::ShellOut).to receive(:new).with(cmd).and_return(shell_out)
    end

    context 'not already running' do
      let(:running?) { false }

      it 'starts Plex Home Theater' do
        path = File.expand_path('/Program Files (x86)/Plex Home Theater/' \
                                'Plex Home Theater.exe')
        cmd = "Start-Process \"#{path}\""
        expect(chef_run).to run_powershell_script('Start Plex Home Theater')
          .with(code: cmd)
      end
    end

    context 'already running' do
      let(:running?) { true }

      it 'does not start Plex Home Theater' do
        expect(chef_run).to_not run_powershell_script('Start Plex Home Theater')
      end
    end
  end
end
