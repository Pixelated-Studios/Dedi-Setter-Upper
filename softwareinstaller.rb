# frozen_string_literal: true
require 'logger'

class SoftwareInstaller
  @@SOFTWARE_LIST = %w[nginx mariadb-server ufw php java wget curl python docker apache percona-server-server
                       rsync].freeze

  def initialize(package_manager)
    raise "Unsupported package manager: #{package_manager}" unless %w[apt yum dnf pacman].include?(package_manager)

    @package_manager = package_manager
    @logger = Logger.new($stdout)
    Curses.init_screen
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
  end

  def run

    Curses.clear
    Curses.setpos(0, 0)
    Curses.addstr('Select software to install:')
    Curses.setpos(2, 0)
    Curses.attron(Curses.color_pair(2))
    @@SOFTWARE_LIST.each_with_index do |software, index|
      Curses.addstr("#{index + 1}. #{software}\n")
    end
    Curses.attroff(Curses.color_pair(2))
    input = Curses.addstr('Enter the number of the software you want to install:')
    if input.to_i.positive? && input.to_i <= @@SOFTWARE_LIST.length
      package_name = @@SOFTWARE_LIST[input.to_i - 1]
      command = "#{@package_manager} install -y #{package_name} --no-install-recommends"
      Curses.clear
      Curses.addstr("Installing #{package_name} and its dependencies...")
      Curses.refresh
      if system(command)
        Curses.addstr("#{package_name} and its dependencies have been successfully installed.")
        @logger.info("#{package_name} and its dependencies have been successfully installed.")
      else
        error_message = `#{command} 2>&1`
        Curses.addstr("Failed to install #{package_name} and its dependencies: #{error_message}")
        @logger.error("Failed to install #{package_name} and its dependencies: #{error_message}")
      end
      Curses.addstr('Press any key to continue...')
    else
      Curses.addstr("Invalid input, please enter a number between 1 and #{@@SOFTWARE_LIST.length}")
    end
    Curses.getch
rescue StandardError => e
  @logger.error("Error : #{e.message}")
ensure
  Curses.close_screen

  end
end
