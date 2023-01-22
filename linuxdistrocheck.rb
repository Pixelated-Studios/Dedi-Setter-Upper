class LinuxDistribution
  attr_reader :distribution

  def initialize
    @distribution = detect
  end

  def detect
    return unless File.exist?('/etc/os-release')

    File.open('/etc/os-release').each do |line|
      return line.split('=')[1].strip.gsub(/"/, '') if line.start_with?('NAME=')
    end
  end
end