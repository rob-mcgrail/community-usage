require 'net/http'

# Lengthen timeout in Net::HTTP
module Net
    class HTTP
        alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = 3*60     # 3 minutes
        end
    end
end

module Stats

  #
  # A mixin for the site.rb class
  #
  # Supplied API calls/getter methods for stats:
  #
  # @@sites.portal.visits
  #
  # @@sites.values.each {|site| @all_pageviews << site.pageviews}
  #
  # See the classes in /reports/ for examples
  #

  basic_stats = [:visits, :visitors, :pageviews, :new_visits, :bounces, :time_on_site, :entrances, :exits, :total_events]

  #
  # Array above is used to create methods of the same name
  # They create an instance variable of the same name,
  # and also act as getters for that variable once the method has run once,
  # to avoid querying the API multiple times for same stat
  #
  # These methods all expect only one value to be returned by GA
  #
  # Use self.flush('variable_name') (sans @) to reset the instance variable to nil
  # Or self.flush_all to clear all stats.
  #
  # This is done for you when using Report.new_zealndify / Report.de_new_zealandify
  #

  basic_stats.each do |arg|
    method_name = (arg)
    instance_arg = ('@'+arg.to_s).to_sym
    send :define_method, method_name do
      if self.instance_variable_get(instance_arg).nil? # Check if method has run already
        begin

          report = Garb::Report.new(@profile, :start_date => $start_date, :end_date => $end_date)

          # Check for segments
          #
          # Segments live in @slice - a hash with :total and :nz
          #
          # All site objects should have an @slice[:nz] segment, most sites
          # will have a nil @slice[:total] segment (because they have their own profiles)
          #

          if self.slice? and self.nz == nil
            report.set_segment_id(@slice[:total])
          end
          if self.nz?
            report.set_segment_id(@slice[:nz])
          end

          report.metrics arg # API query

        rescue Garb::DataRequest::ClientError, Timeout::Error
          puts "#{@name} suffered a request error for #{arg}. Trying again."
          retry       
        end

        #
        # Check result - sets to 0.0 if nothing is returned -
        # (stops script breaking when some communities have no data in date range)
        #
        # Values are returned as arrays of ostructs, with individual values as strings
        # These are converted to floats as to_f can handle strings of sci notation, which GA
        # uses for very large values
        #
        begin
          if report.results.length == 1
            self.instance_variable_set(instance_arg, report.results.first.send(arg).to_f) # Set instance variable
          elsif report.results.length == 0
            puts "Stats##{arg.to_s} returned nothing. You may be seeking data outside of #{self.name}'s valid range..."
            self.instance_variable_set(instance_arg, 0.0)
          else
            raise "Stats##{arg.to_s} returned more than one value. This means something is wrong."
          end
        rescue Garb::DataRequest::ClientError, Timeout::Error
          puts "#{@name} suffered a request error for #{arg}. Trying again."
          retry       
        end
      else
        #getter - returns instance variable of the same name as method
        self.instance_variable_get(instance_arg)
      end
    end
  end

  def returning_visits
    # This is not the metric from the web interface
    if @returning_visits.nil?
      @returning_visits = self.visits - self.new_visits
    else
      @returning_visits
    end
  end

  def new_visitors

    # Can't be declared with the rest as requires a dimension
    # This is the metric from the web interface

    if @new_visitors.nil?
      begin
        report = Garb::Report.new(@profile, :start_date => $start_date, :end_date => $end_date)

        if self.slice? and self.nz == nil
          report.set_segment_id(@slice[:total])
        end
        if self.nz?
          report.set_segment_id(@slice[:nz])
        end

        report.metrics :visits
        report.dimensions :visitorType

      rescue Timeout::Error, Garb::DataRequest::ClientError
        puts "#{@name} suffered a request error for #{arg}. Trying again."
        retry
      end
      
      begin
        if report.results.length == 2
          report.results.each do |result|

            # Creates both instance variables -
            # @new_visitors, @returning_visitors
            # based on the dimension names returned by GA

            var_name = ('@'+result.visitor_type.downcase.tr(" ", "_")+'s')
            self.instance_variable_set(var_name.to_sym, result.visits.to_f)
          end
          @new_visitors
        elsif report.results.length == 0
          puts "Stats#new_visitors returned nothing. You may be seeking data outside of #{self.name}'s valid range..."
        else
          puts "Stats#new_visitors returned more than two values. This means something is wrong."
        end
      rescue Timeout::Error, Garb::DataRequest::ClientError
        puts "#{@name} suffered a request error for #{arg}. Trying again."
        retry
      end
    else
      @new_visitors
    end
  end

  def returning_visitors

    # getter for instance variable created in the method above
    # runs the method above if variable is nil

    if @returning_visitors.nil?
      self.new_visitors
    else
      @returning_visitors
    end
  end

  def bouncerate
    # This is a derivative metric

    if @bouncerate.nil?
      # @bouncerate = MathHelper.percentage(self.bounces, self.visits, 2) #spread sheet copes better with decimals...
      @bouncerate = self.bounces/self.visits
    else
      @bouncerate
    end
  end

  def average_time
    # This is a derivative metric
    if @average_time.nil?
      time = self.time_on_site/self.visits
      if self.visits == 0.0
        time = 0.0
      end
      # @average_time = MathHelper.make_minutes(time) #the spreadsheet hates these actual times
      @average_time = time
      @average_time
    else
	  @average_time
	end
  end

  def pages_per_visit
    if @pages_per_visit.nil?
      @pages_per_visit = self.pageviews/self.visits
    else
      @pages_per_visit
    end
  end

  def flush(var)
    #
    # Used to reset an instance variable to nil -
    # (using attr_writer breaks dynamic methods at the start of class)
    #
    # Argument is variable name as a string, without the @
    #

    variable = ('@'+var).to_sym
    self.instance_variable_set(variable, nil)
  end

  def flush_all #TODO make basic stats not just dumped in - how to acces variable outside of method
    basic_stats = [:visits, :visitors, :pageviews, :pages_per_visit, :new_visits, :bounces, :time_on_site, :entrances, :exits, :total_events, :average_time, :bouncerate, :returning_visitors, :new_visitors, :returning_visits]
    basic_stats.each do |var|

      variable = ('@'+var.to_s).to_sym
      self.instance_variable_set(variable, nil)
    end
  end

end

