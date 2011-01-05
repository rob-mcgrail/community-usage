require 'date'

class Date

  # Packing this in to date is a lot simpler than relying on whatever version of active_support has this method,
  # and fighting with garb over requiring it...
  
  def days_in_month
    m = self.month
    
    if m == 12 # Handling December
      m = 1
      y = self.year
      y += 1
    else
      y = self.year
      m += 1
    end
    
    d = Date.new(y, m)
    d = d - 1
    d.day
  end
  
  def beginning_of_month
    Date.new(self.year, self.month)
  end
  
  def end_of_month
    Date.new(self.year, self.month, self.days_in_month)
  end
  
end