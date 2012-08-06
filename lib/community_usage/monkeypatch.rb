# Coding in the API key aparameter to avoid restrictions on api calls.
#
# https://developers.google.com/analytics/resources/articles/gdata-migration-guide

module Garb
  class DataRequest
    def query_string
      @parameters.merge!("key" => "AIzaSyBlAAssnuA0Rpa3ReabOlnEDfcxcAyWTYY")
      parameter_list = @parameters.map {|k,v| "#{k}=#{v}" }
      parameter_list.empty? ? '' : "?#{parameter_list.join('&')}"
    end
  end
end
