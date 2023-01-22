# frozen_string_literal: true

class SystemUpdate
  def initialize(update_command, upgrade_command)
    @update_command = update_command
    @upgrade_command = upgrade_command
  end

  def run
    puts 'Starting system update...'
    run_command(@update_command)
    run_command(@upgrade_command, 'upgraded')
    puts 'System update complete.'
  end

  private

  def run_command(command, progress_text = nil)
    Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      stdout.each_line { |line| puts line if progress_text.nil? || line.include?(progress_text) }
      puts "#{command} Successful" if wait_thr.value.success?
      puts "#{command} failed" unless wait_thr.value.success?
    end
  end
end
