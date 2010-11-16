module MathHelper
  
  def self.percentage(given, total, precision = nil)
    given = given.to_f
    total = total.to_f

    if total == 0.0
      puts "Trying to get a percentage of nothing!"
      return 0.0
    end

    i = (given/total)*100
    
    if precision
      i = MathHelper.round_f(i, precision)
    end
    i
  end
  
  def self.make_minutes(i)
    time = Time.at(i.to_i)
    time = time.strftime("%M.%S")
  end
  
  def self.round_f(i, precision)    
    str = "%.#{precision}f" % i
    i = str.to_f
  end
  
end