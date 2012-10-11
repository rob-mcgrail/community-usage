class Site
	attr_reader :name, :code, :profile
	attr_accessor :segment, :nz
	include Stats

	def initialize(name, code, community, total, slice)
		@name = name
		@code = code
		@community = community
		@total = total
		@slice = slice
		@nz = nil
		begin
	    @profile = Garb::Management::Profile.all.detect {|p| p.id == @code}
	  rescue Timeout::Error
	    puts 'Timed out booting up site profile from GA, trying again.'
      @profile = Garb::Management::Profile.all.detect {|p| p.id == @code}
	  end
	end

	#
	#
	# Methods for sorting through the list of sites, like:
	#
	# @@sites.values.each do |site|
	#   @total_for_community += site.visits if site.is_community?
	# end
	#

	def community_page?
		@community
	end
  alias :communities? :community_page?

	def is_segment?
		@slice[:total]
	end
  alias :slice? :is_segment?

  def is_for_total?
    @total
  end
  alias :total? :is_for_total?

	def is_nz?
	  @nz
	end
	alias :nz? :is_nz?

end

