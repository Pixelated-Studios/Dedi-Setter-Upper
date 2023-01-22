class SystemUpdate
  attr_reader :update_command, :upgrade_command

  def initialize(update_command, upgrade_command)
    validate_inputs(update_command, upgrade_command)
    @update_command = update_command
    @upgrade_command = upgrade_command
  end

  def run
    puts 'Starting system update...'

    if already_updated?
      puts 'System is already up-to-date, skipping update command.'
    else
      run_command(@update_command)
    end
    run_command(@upgrade_command, 'upgraded')
    puts 'System update complete.'
  end

  private

  def validate_inputs(update_command, upgrade_command)
    raise 'Update command cannot be empty' if update_command.strip.empty?
    raise 'Upgrade command cannot be empty' if upgrade_command.strip.empty?
    raise 'Update command not found in the system' unless command_exists?(update_command)
    raise 'Upgrade command not found in the system' unless command_exists?(upgrade_command)
    raise 'Update command not compatible with the current system' unless command_compatible?(update_command)
    raise 'Upgrade command not compatible with the current system' unless command_compatible?(upgrade_command)
    raise 'Update command does not have the required permission to execute' unless command_permission?(update_command)
    raise 'Upgrade command does not have the required permission to execute' unless command_permission?(upgrade_command)
  end

  def already_updated?
    # Example: check if the system is already up-to-date by comparing the current version with the latest version available
    current_version = `lsb_release -r`.split[1]
    latest_version = `curl -s https://example.com/latest_version`.strip
    current_version == latest_version
  end

  def command_exists?(command)
    # Example: check if the command exists in the system by running the command and checking its exit status
    system("which #{command} > /dev/null 2>&1")
  end

  def command_compatible?(command)
    # Example: check if the command is compatible with the current system by comparing the current version with the version the command is compatible with
    current_version = `lsb_release -r`.split[1]
    compatible_version = `#{command} --version-compat`.strip
    current_version >= compatible_version
  end

  def command_permission?(command)
    # Example: check if the command has the required permission to execute by using the File.executable? method
    File.executable?(command)
  end

  def run_command(command, progress_text = nil, capture_output = false)
    output = []
    success = system(command, out: capture_output ? output : $stdout, err: capture_output ? output : $stderr)
    if progress_text
      output.each do |line|
        puts line if line.include?(progress_text)
      end
    end
    puts "#{command} Successful" if success
    puts "#{command} failed" unless success
    output
  end
end

