#!/bin/Ruby
# frozen_string_literal: true

require 'English'
require 'open3'
require 'curses'

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


