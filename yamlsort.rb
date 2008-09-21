# This is a script for vim-ruby for sorting collections
#
# Author: Igor Vergeichik <iverg@mail.ru>
# Sponsor: Tom Sawyer <transami@transami.net>
# Copyright (c) 2002 Tom Saywer

class YCollection
	def initialize(rule)
		@buffer=VIM::Buffer.current
		@window=VIM::Window.current
		@lnum = @window.cursor[0]
		@key=@buffer[@lnum].scan(/^([^:]+[^\s])\s*:/)
		# Find collection bounds
		r = bounds
		# If collection found - resort it
		replace(r, resort((parse r), rule)) if r[1]>0
	end
	
	# Detect bounds of YAML collection
	# Input: no
	# Output: Array - range of detected collection
	def bounds
		lnum = @lnum
		# If line begins with a dash - this is one of collection items
		if @buffer[lnum]=~/\s*-/
			coll_bounds(lnum)
		else
		# otherwise we need to find parent item
			ind = VIM::evaluate("indent(#{lnum})").to_i
			while lnum>0 
				if VIM::evaluate("indent(#{lnum})").to_i<ind
					 return coll_bounds(lnum)
				else lnum=lnum-1
				end
			end
			# No parent item found - no collection detected
			[0, 0]
		end
	end

	# Detect bounds of YAML collection
	# Called only for line which is a item of collection
	# Input: line number
	# Output: Array - range of detected collection
	def coll_bounds(lnum)
		ind = VIM::evaluate("indent(#{lnum})").to_i
		start = fin = lnum
		# Detect beginning of collection
		ln = lnum - 1
		while ln>0
			curr_ind = VIM::evaluate("indent(#{ln})").to_i
			break if curr_ind<ind || (curr_ind==ind && @buffer[ln]!~/\s*-/)
			start = ln
			ln = ln - 1
		end
		# Detect end of collection
		ln = lnum + 1
		while ln<=@buffer.count
			curr_ind = VIM::evaluate("indent(#{ln})").to_i
			break if curr_ind<ind || (curr_ind==ind && @buffer[ln]!~/\s*-/)
			fin = ln
			ln = ln + 1
		end
		[start,fin]
	end

	# Parse data in YAML collection to separate collection's items
	# Input: range of lines of collection in document
	# Output: Array, each element is weight and Array of lines
	def parse(range)
		idx = -1
		data = Array.new
		ind = VIM::evaluate("indent(#{range[0]})").to_i
		range[0].upto(range[1]) do |x|
			if VIM::evaluate("indent(#{x})").to_i==ind
				idx = idx+1
				data[idx]=Array.new
				data[idx][0]=Array.new
			   	data[idx][1]=@buffer[x].scan(/\s*(.*)\s*$/) if @key.empty?
			end
			data[idx][1]=@buffer[x].scan(/:(.*)$/) if @buffer[x]=~/^#{@key}\s*:/
			data[idx][0].push @buffer[x]
		end
		data
	end

	# Sort collection.
	# Input: parsed collection, sorting rule (lambda)
	# Output: Sorted array of collection's lines
	def resort(data, rule)
		lines = Array.new
		data.sort { |a,b|
			if a[1].nil? 
				1
			elsif b[1].nil?
				-1
			else 
				rule.call(a[1], b[1])
			end
		}.each { |x| x[0].each { |y| lines.push y }}
		lines
	end
	
	# Replace lines of collection in document with sorted lines
	def replace(range, lines)
		range[0].upto(range[1]) {|x| @buffer[x] = lines[x-range[0]] }
	end
end

# Init collection
#YCollection.new lambda {|a,b| b<=>a}

