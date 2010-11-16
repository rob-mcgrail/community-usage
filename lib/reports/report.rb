class Report
  include Sites
  
  #
  # Parent report class
  #
  
  def initialize
    
    #
    # Calls the Sites mixin - this imports the site details into the hash @sites
    #
    # Iterate through the sites like:
    # @sites.each {|key, site_object| puts site_object.name}
    #
    # Site keys are their names:
    # @sites[:portal].profile
    # @sites[:promoting_healthy_lifestyles].visitors
    #
    # sites have tests for their place in TKI (see site.rb), so you can go:
    #  @sites.each do |k, site|
    #    next unless site.legacy?
    #    @legacy_visits += site.visits
    #  end
    #
    # See stats.rb (a mixin for the site objects) for the available stats calls
    #
    # See site.rb for the other site_object getters
    #
    # See sites.rb for the list
    #
    
    if !defined? @@sites  
      @@sites = get_sites
    end
  end
  
  def sites?
    # Called from sites.rb module to avoid fetching sites twice    
    defined? @@sites
  end
  
  def self.new_zealandify
    @@sites.values.each {|site| site.flush_all; site.nz = true}
  end
  
  def self.de_new_zealandify
    @@sites.values.each {|site| site.flush_all; site.nz = nil}
  end
  
  def self.set_to_previous_month
    $dates_backup = {:start => $start_date, :end => $end_date} #backing up dates
    
    @@sites.values.each {|site| site.flush_all}
    
    $start_date = $start_date.to_datetime 
    $end_date = $end_date.to_datetime
    $start_date = ($start_date - 15.days).beginning_of_month
    $end_date = ($end_date - 40.days).end_of_month
  end
  
  def self.back_to_report_month
    if $start_date != $dates_backup[:start]
      @@sites.values.each {|site| site.flush_all}
      $start_date = $dates_backup[:start]; $end_date = $dates_backup[:end] #reset dates
    end
  end
  
  def check(data)
    # A quick check to make sure the data hash isn't broken
    
    arrays = data.values
    x = arrays.first.length
    arrays.each do |a|
      if a.length != x
        raise "data hash in a report object is broken - you can't use this with the Export#to_csv method"  
      end
    end
  end
  
end