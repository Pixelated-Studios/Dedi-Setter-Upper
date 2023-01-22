#!/bin/Ruby
# frozen_string_literal: true

require 'open3'

# First, let's get what kind of system we are running on
def detect_linux_distribution
  return unless File.exist?('/etc/os-release')

  File.open('/etc/os-release').each do |line|
    return line.split('=')[1].strip.gsub(/"/, '') if line.start_with?('NAME=')
  end

end

distribution = detect_linux_distribution
puts "Running on #{distribution}."

# Now, let's figure out what package manager the system is using so we can run some commands with it
def detect_package_manager
  package_manager = `command -v yum || command -v dnf || command -v apt-get || command -v pacman || command -v zypper`
  package_manager.strip
end

package_manager = detect_package_manager
# Now, let's setup our variables for doing a system update
update_command = "#{package_manager} update"
upgrade_command = "#{package_manager} upgrade"

puts 'Starting system update...'

# We are going to use the Open3 library to start our stdin, out, err, and wait_thr streams
Open3.popen3(update_command) do |_stdin, stdout, _stderr, wait_thr|
  while (line = stdout.gets)
    puts line
  end
  # here we are checking the status of the command that we just ran. Above, we wait for the command to finish
  # before we check
  exit_status = wait_thr.value
  if exit_status.success?
    puts 'Update Command Successful'
  else
    puts 'Update Command failed'
  end
end
# Here, we are actually going to run our commands, open our stdout stream and display the package name
# and it's install progress. After, we check if it was successful or not by checking the command status
Open3.popen3(upgrade_command) do |_stdin, stdout, _stderr, wait_thr|
  while (line = stdout.gets)
    next unless line.include?('upgraded,')

    package_name = line.split(',')[0].strip
    progress = line.split(',')[1].strip
    puts "Installing #{package_name}: #{progress}"
  end
  exit_status = wait_thr.value
  if exit_status.success?
    puts 'Upgrade Command Successful'
  else
    puts 'Upgrade Command failed'
  end
end

puts 'System update complete.'

