module Interface

  def start
    # Basic startup routine - gets credentials and dates, starts session

    self.authenticate_session
    self.select_dates
  end

  module_function :start

  def self.authenticate_session
    self.get_credentials
    begin
      Garb::Session.login(@username, @password)
    rescue Garb::AuthenticationRequest::AuthError
      puts "Bad credentials! Try again\n\n"
      self.authenticate_session
    end
  end

  def self.get_credentials
    puts 'Username'
    @username = gets.chomp
	  puts 'Password - in the clear'
    @password = gets.chomp
  end

  def self.select_dates
    puts 'Enter the start date (inclusive) for the reporting period (dd/mm/yyyy)'
    $start_date = Date.strptime(gets.chomp, "%d/%m/%Y")

    puts 'Enter the end date (inclusive) for the reporting period (dd/mm/yyyy)'
    $end_date = Date.strptime(gets.chomp, "%d/%m/%Y")

    puts "Reporting period is #{$start_date} through #{$end_date}, inclusive.\n"
  end
end

