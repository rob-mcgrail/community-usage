class AnnualCuriosities < Report
  
  [:visits, :visitors, :pageviews, :new_visits, :bounces, :time_on_site, :entrances, :exits, :total_events].each do |arg|
    methods = {}
    method_name = ('highest_'+arg.to_s).to_sym
    methods[:highest] = method_name
    send :define_method, method_name do |limit|
      i = limit || 5
      things=[]
      @@sites.each do |k,v|
        if v.is_for_total?
          things << [v.name, v.send(arg)]
        end
      end

      things.sort! {|a,b| b[1] <=> a[1]}

      data = []
      things[0..(i-1)].each do |thing|
        data << "#{thing[0]}: #{thing[1]}"
      end
      
      data
    end
    
    method_name = ('lowest_'+arg.to_s).to_sym
    methods[:lowest] = method_name
    send :define_method, method_name do |limit|
      i = limit || 5
      things=[]
      @@sites.each do |k,v|
        if v.is_for_total?
          things << [v.name, v.send(arg)]
        end
      end

      things.sort! {|a,b| a[1] <=> b[1]}
      
      data = []
      things[0..(i-1)].each do |thing|
        data << "#{thing[0]}: #{thing[1]}"
      end
      
      data    
    end
    
    send :define_method, arg do |limit|
      data = []
      data << "Highest for #{arg}"
      data = data + self.send(methods[:highest])
      data << "Lowest for #{arg}"
      data = data + self.send(methods[:lowest])
      data
    end
    
  end
  
  def growing(limit=5)
    data = self.change(limit) do |a|
      a.sort! {|a,b| b[:change] <=> a[:change]} #make two methods with this in a block using yield?
    end
    
    data
  end
  
  def shrinking(limit=5)
    data = self.change(limit) do |a|
      a.sort! {|a,b| a[:change] <=> b[:change]} #make two methods with this in a block using yield?
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
    
    yield rates
    
    data = []
    rates[0..(i-1)].each do |rate|
      data << "#{rate[:name]}: #{rate[:change]}%"
    end
    data
  end

end