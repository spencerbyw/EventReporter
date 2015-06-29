def load_helper
	# Get the length of the longest string from each column so everything can be formatted nicely
	@loaded_data.each do |row|
		
		# Prevent nil values and clean so that .length method works
		row.each_with_index do |(key, value), index|
			row[:zipcode] = clean_zipcode(row[:zipcode])
			row[:homephone] = clean_phone_number(row[:homephone])
			if value == nil
				row[index] = " "
			end
		end

		# Make sure the column width is right
		@column_lengths[:last_name] = [@column_lengths[:last_name], row[3].length].max
		@column_lengths[:first_name] = [@column_lengths[:first_name], row[2].length].max
		@column_lengths[:email] = [@column_lengths[:email], row[4].length].max
		@column_lengths[:zipcode] = [@column_lengths[:zipcode], row[-1].length].max
		@column_lengths[:city] = [@column_lengths[:city], row[-3].length].max
		@column_lengths[:state] = [@column_lengths[:state], row[-2].length].max
		@column_lengths[:address] = [@column_lengths[:address], row[-4].length].max
		@column_lengths[:phone] = [@column_lengths[:phone], row[-5].length].max
	end
end

def sum_column_lengths
	# get sum of lengths
	sum = 0
	@column_lengths.each_value do |value|
		sum += value
		sum += 2
	end
	sum
end

def save_queue(params)	
	Dir.mkdir("output") unless Dir.exists? "output"
	filename = "output/#{params[1]}"
	printf "Saving to #{filename}..."
	CSV.open(filename, 'w',
		:write_headers => true,
		:headers => @loaded_data.headers
		) do |file|
			@the_queue.each do |row|
				file << row
			end
	end
	puts " Done."
end

def print_row_headers
	# Properly print row headers
	puts "".rjust(sum_column_lengths, '-')
	printf "%-#{@column_lengths[:last_name] + 2}s", "LAST NAME"
	printf "%-#{@column_lengths[:first_name] + 2}s", "FIRST NAME"
	printf "%-#{@column_lengths[:email] + 2}s", "EMAIL"
	printf "%-#{@column_lengths[:zipcode] + 2}s", "ZIPCODE"
	printf "%-#{@column_lengths[:city] + 2}s", "CITY"
	printf "%-#{@column_lengths[:state] + 2}s", "STATE"
	printf "%-#{@column_lengths[:address] + 2}s", "ADDRESS"
	printf "%-#{@column_lengths[:phone] + 2}s", "PHONE"
	printf "\n" # puts "LAST NAME       FIRST NAME  EMAIL                                  ZIPCODE     CITY                    STATE  ADDRESS                              PHONE"
	puts "".rjust(sum_column_lengths, '-')
end

def print_queue(queue)
	total_records = queue.to_a.size
	start = 0
	start_to = 0
	queue.each_slice(10) do |slice|
		slice.each do |row|
			printf "%-#{@column_lengths[:last_name] + 2}s", "#{row[:last_name]}"
			printf "%-#{@column_lengths[:first_name] + 2}s", "#{row[:first_name]}"
			printf "%-#{@column_lengths[:email] + 2}s", "#{row[:email_address]}"
			printf "%-#{@column_lengths[:zipcode] + 2}s", "#{row[:zipcode]}"
			printf "%-#{@column_lengths[:city] + 2}s", "#{row[:city]}"
			printf "%-#{@column_lengths[:state] + 2}s", "#{row[:state]}"
			printf "%-#{@column_lengths[:address] + 2}s", "#{row[:street]}"
			printf "%-#{@column_lengths[:phone] + 2}s", "#{row[:homephone]}"
			printf "\n" # puts "#{row[3]}\t\t#{row[2]}\t#{row[4]}\t#{row[-1]}\t#{row[-3]}\t#{row[-2]}\t#{row[-4]}\t#{row[-5]}"
		end
		# get correct "to" value
		if (start + 10) < total_records
			start_to = start + 10
		else
			start_to = total_records
		end
		puts "Displaying records #{start} - #{start_to} of #{total_records}"

		if total_records > 10
			puts "Press the space bar or enter key to show the next set of records..."
			start += 10
			gets.chomp
		end
	end
	# puts " "
	
end

def valid_header(attribute)
	if @loaded_data.headers.any? {|a| a == :"#{attribute}"}
		# puts "Attribute input is good, proceeding to pull data..."
		true
	else
		# puts "The attribute you entered was invalid."
		false
	end
end