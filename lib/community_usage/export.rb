module Export
  require 'csv'
  require 'fileutils'

  #
  # Scripts should start like:
  #
  # Interface.start #Get date range, athenticate with GA
  #
  # Export.make_directory #Create directory for CSVs
  #

    def self.make_directory(dir = $start_date.strftime("%h-%y").to_s.downcase)
      @path = File.expand_path(File.dirname(__FILE__) + "/../../output/#{dir}")
      FileUtils.mkdir_p @path
    end

    def self.to_csv(data, file_name_stub)

      #
      # Called from the main script:
      # Export.to_csv(CommunitiesTable.new.full, 'communities_table')
      #
      # Expects a hash of arrays - hash keys are used for column names in csv
      #
      # Each array should be values of one type - all visits, all bouncerates etc
      #

      file_name = file_name_stub + '-' + $start_date.strftime("%h-%y").to_s.downcase + '.csv'
      file = File.new(@path+"/#{file_name}", 'w+')

      CSV::Writer.generate(file) do |csv|

        header=[]

        data.each_key {|k| header << k.to_s}  # Put key names in to array - there are column names
        header.sort! #Sort alphabetically, for consistency

        if header.include? 'name'         # Keeping 'name' as first column. Helps with VLOOKUP in spreradsheet...
          header.reject! {|x| x == 'name'}
          header = header.unshift('name')
        end

        csv << header; puts header

        i = 0; x = 0

        # Grab a key, and get the length of its array
        # This tells how many rows are required

        k = header[0]
        rows = data[k.to_sym].length

        # Iterate for each row, grabing the respective value from each array in the hash,
        # Calling each in alphabetical order (by cycling through the header array sorted above)

        rows.times do
          temp=[]
          x = 0
          data.length.times do
            k = header[x]
            a = data[k.to_sym]
            temp << a[i]
            x += 1
          end
          csv << temp; puts temp
          i += 1
        end

      end

    end
end

