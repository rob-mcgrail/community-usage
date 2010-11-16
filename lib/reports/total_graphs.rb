class TotalGraphs < Report
  #
  # These methods are EXTREMELY slow (400-500 or so queries each, typically run 8 times)
  #

  [:pageviews, :visitors].each do |method_name|
    send :define_method, method_name do |arg|
      months = arg

      metrics = [method_name, :month]

      data={}
      metrics.each {|m| data[m]=[]} # Create hash keys

      dates={:start => $start_date, :end => $end_date} #backing up dates
      i = 0

      # active_support methods used here need datetimes
      $start_date = $start_date.to_datetime
      $end_date = $end_date.to_datetime

      # Get values using regular months
      v = 0

      @@sites.values.each {|site| v += site.send(method_name)}

      data[method_name] << v
      data[:month] << $start_date.strftime("%h")


      # Get values incrimenting through months
      #
      # This looks horrible because ruby's Date class doesn't have real month methods
      #
      # The -15.days is a hack to enter the appropriate month,
      # and then use active_supports beginning/end of month methods
      #

      (months-1).times do
        $start_date = ($start_date - 15.days).beginning_of_month
        $end_date = ($end_date - 40.days).end_of_month

        v = 0
        # The flush method resets the instance variable back to nil, so the stats method will run again
        @@sites.values.each {|site| site.flush(method_name.to_s); v += site.send(method_name)}

        data[method_name] << v
        data[:month] << $start_date.strftime("%h")
        i += 1
      end

      $start_date = dates[:start]; $end_date = dates[:end] #reset dates

      self.check(data)
      data
    end
  end

end

