class AnnualCuriosities < Report
  
  [:visits, :visitors, :pageviews, :new_visits, :bounces, :time_on_site, :entrances, :returning_visits, :exits, :total_events].each do |arg|
    
    send :define_method, (arg.to_s+'_generic').to_sym do |limit|
      i = limit || 5
      things=[]
      @@sites.each do |k,v|
        if v.is_for_total?
          things << [v.name, v.send(arg)]
        end
      end
      
      yield things if block_given?
      
      data = []
      
      things[0..(limit-1)].each do |thing|
        data << "#{thing[0]}: #{thing[1]}"
      end
      
      data
    end
    
    send :define_method, ('lowest_'+arg.to_s).to_sym do |limit|
      data = self.send(arg.to_s+'_generic').to_sym do |a|
        a.sort! {|a,b| a[1] <=> b[1]}
      end
      
      data[0..(limit-1)].each do |thing|
        data << "#{thing[0]}: #{thing[1]}"
      end
      
      data
    end
    
    send :define_method, ('highest_'+arg.to_s).to_sym do |limit|
      data = self.send(arg.to_s+'_generic').to_sym do |a|
        a.sort! {|a,b| b[1] <=> a[1]}
      end
      
      data[0..(limit-1)].each do |thing|
        data << "#{thing[0]}: #{thing[1]}"
      end
      
      data
    end
    
    send :define_method, arg do |limit|
      data = []
      data << "Highest for #{arg}"
      data = data + self.send(('highest_'+arg.to_s).to_sym, limit)
      data << "Lowest for #{arg}"
      data = data + self.send(('lowest_'+arg.to_s).to_sym, limit)
      data
    end
    
  end
  
  
  def new_returning(limit=5)
    visits = visits_generic(limit)
    returnings = returning_visits_generic(limit)
    ratios = []
    i = 0
    returnings.each do |r|
      ratios << [r[0], (r[1]/visits[i][1])*100]
      i+=1
    end
    
    yield ratios
    
    data = []
    ratios[0..(i-1)].each do |ratio|
      data << "#{ratio[0]}: #{ratio[1]}%"
    end
    data
  end
  
  def new_returning_highest(limit=5)
    data = self.new_returning(limit) do |a|
      a.sort! {|a,b| b[1] <=> a[1]}
    end
    
    data
  end
  
  def new_returning_lowest(limit=5)
    data = self.new_returning(limit) do |a|
      a.sort! {|a,b| a[1] <=> b[1]}
    end
    
    data
  end
  
  
  def growing(limit=5)
    data = self.change(limit) do |a|
      a.sort! {|a,b| b[:change] <=> a[:change]}
    end
  
    data
  end
  
  def shrinking(limit=5)
    data = self.change(limit) do |a|
      a.sort! {|a,b| a[:change] <=> b[:change]}
    end
    
    data
  end
  
  def change(limit=5)
    $dates_backup = {:start => $start_date, :end => $end_date} #backing up dates
    @@sites.values.each do |site| 
      if site.is_for_total?
        site.flush 'visitors'
      end
    end
    
    $end_date = $end_date << 6
    
    raise 'Trying to do annual things with a non-annual date range. Stop!' if $end_date < $start_date
    
    rates = []
    @@sites.each do |k,v|
      if v.is_for_total?
        rates << {:name => v.name, :early_visitors => v.visitors, :later_visitors => '', :change => ''}
      end
    end
    
    @@sites.values.each do |site|
      if site.is_for_total?
        site.flush 'visitors'
      end
    end
    
    $end_date = $dates_backup[:end]
    $start_date = $start_date >> 6

    i = 0
    @@sites.each do |k,v|
      if v.is_for_total?
        rates[i][:later_visitors] = v.visitors
        i += 1
      end
    end
    
    rates.each do |x|
      if x[:early_visitors].to_i == 0
        x[:change] = 999999999999999
      else
        x[:change] = (x[:later_visitors].to_i-x[:early_visitors].to_i)/x[:early_visitors] * 100
      end
    end
    
    $start_date = $dates_backup[:start]; $end_date = $dates_backup[:end] #reset dates
    
    yield rates if block_given?
    
    data = []
    rates[0..(i-1)].each do |rate|
      data << "#{rate[:name]}: #{rate[:change]}%"
    end
    data
  end

end