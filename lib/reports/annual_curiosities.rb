class AnnualCuriosities < Report
  
  [:visits, :visitors, :pageviews, :new_visits, :bounces, :time_on_site, :entrances, :exits, :total_events].each do |arg|
    method_name = ('highest_'+arg.to_s).to_sym
    send :define_method, method_name do |limit|
      i = limit || 5
      things=[]
      @@sites.each do |k,v|
        if v.is_for_total?
          things << [v.name, v.send(arg)]
        end
      end

      things.sort! {|a,b| b[1] <=> a[1]}
      puts things[0..(i-1)]      
    end
    
    method_name = ('lowest_'+arg.to_s).to_sym
    send :define_method, method_name do |limit|
      i = limit || 5
      things=[]
      @@sites.each do |k,v|
        if v.is_for_total?
          things << [v.name, v.send(arg)]
        end
      end

      things.sort! {|a,b| a[1] <=> b[1]}
      puts things[0..(i-1)]      
    end
    
  end
  
  def growing(limit=5)
    $dates_backup = {:start => $start_date, :end => $end_date} #backing up dates
    @@sites.values.each {|site| site.flush 'visitors'}
    
    $end_date = $end_date << 6
    
    rates = []
    @@sites.each do |k,v|
      if v.is_for_total?
        rates << {:name => v.name, :early_visitors => v.visitors, :early_visitors => '', :change => ''}
      end
    end
    
    @@sites.values.each {|site| site.flush 'visitors'}
    
    $end_date = $dates_backup[:end]
    $start_date = $start_date >> 6
    
    i = 0
    @@sites.each do |k,v|
      if v.is_for_total?
        rates[i][:later_visitors] = v.visitors
      end
    end
    
    rates.each do |x|
      if x[:early_visitors].to_i == 0
        x[:change] = 999999999999999
      else
        x[:change] = (x[:later_visitors].to_i-x[:early_visitors].to_i)/x[:early_visitors].to_i * 100
      end
    end
    
     $start_date = $dates_backup[:start]; $end_date = $dates_backup[:end] #reset dates
    
    rates.sort! {|a,b| b[:change] <=> a[:change]}
    puts rates[0..(i-1)]      
  end

  # end

end