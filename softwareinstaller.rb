# frozen_string_literal: true
class SoftwareInstaller
  def initialize
    Curses.init_screen
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
    @software_list = %w[nginx mariadb-server ufw php java wget curl python docker apache percona-server-server rsync]
  end

  def run
    Curses.init_screen
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
    begin
      Curses.clear
      Curses.setpos(0, 0)
      Curses.addstr('Select software to install:')
      Curses.setpos(2, 0)
      Curses.attron(Curses.color_pair(2))
      @software_list.each_with_index do |software, index|
        Curses.addstr("#{index + 1}. #{software}\n")
      end
      Curses.attroff(Curses.color_pair(2))
      input = Curses.getstr("Enter the number of the software you want to install:")
      if input.to_i.positive? && input.to_i <= @software_list.length
        package_name = @software_list[input.to_i - 1]
        package_manager = detect_package_manager
        command = "#{package_manager} install -y #{package_name} --no-install-recommends"
        Curses.clear
        Curses.addstr("Installing #{package_name} and its dependencies...")
        Curses.refresh
        system(command)
        if $CHILD_STATUS.success?
          Curses.addstr("#{package_name} and its dependencies have been successfully installed.")
        else
          Curses.addstr("Failed to install #{package_name} and its dependencies.")
        end
        sleep(2)
      end
    ensure
      Curses.close_screen
    end
  end
end
