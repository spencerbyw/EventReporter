require 'csv'
require_relative 'cleaners'
require_relative 'helpers'

class EventReporter
	# attr_accessor :the_queue, :column_lengths

	def initialize
		puts "Initializing..."
		@the_queue = []
		@column_lengths = Hash.new
		@column_lengths = {last_name: 9, first_name: 10, email: 5, zipcode: 7, city: 4, state: 5, address: 7, phone: 5 }
		@loaded_data = []
	end

	def run
		puts "Welcome to EventReporter"
		command = ""
		while command != "q"
			printf "Enter Command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
			when 'q' 		then puts "Goodbye!"
			when 'help'		then help(parts[1..-1])
			when 'load' 	then load(parts[1])
			when 'queue'	then queue(parts[1..-1])
			when 'find'		then find(parts[1..-1])
			else
				puts "Yeah so I don't know how to \"#{command}\" (enter \"help\" for assistance)"
			end
		end
	end

	def load(the_file)
		puts "Attempting to load #{the_file}..."
		if the_file != nil && File.file?("#{the_file}")
			@loaded_data = CSV.read "#{the_file}", headers: true, header_converters: :symbol
			load_helper
			puts "Loaded!"
		elsif the_file == nil
			@loaded_data = CSV.read "event_attendees.csv", headers: true, header_converters: :symbol
			load_helper
			puts "Loaded!"
		else
			puts "File does not exist, sorry."
		end
	end

	def help(command)
		if command == []
			puts "Available commands:"
			puts "load 							loads event_attendees.csv"
			puts "load <filename>				attempts to load the specified file"
			puts "help 							displays all possibly commands"
			puts "help <command>				displays commands for the specific command"
			puts "queue count 					displays number of records contained in queue"
			puts "queue clear 					clears the queue so you can begin anew"
			puts "queue print 					prints entire queue to screen, sans filter"
			puts "queue print by <attribute> 	prints queue based on an attribute (csv header)"
			puts "queue save to <filename.csv> 	saves what's in the queue to the designated filename"
			puts "find <attribute> <criteria> 	adds rows to queue, e.g. \"find zipcode 11111\""
		else
			commands = command.join(" ")
			case commands
			when "load" 			then puts "hi" # show load <filename> too
			when "help" 			then puts "" # show help <command> too
			when "queue count" 		then puts ""
			when "queue clear" 		then puts ""
			when "queue print" 		then puts "" # show other print option
			when "queue save to" 	then puts ""
			when "find" 			then puts ""
			else
				"Well, looks like I can't really help you with that."
			end
		end
		
	end

	def queue(command_arr)
		# Prevent premature access to the_queue
		if @the_queue.empty?
			puts "There needs to be something in the queue first. (Use the \"find\" command)"
			return nil
		end

		# QUEUE HANDLER ----------------------------------
		# Perform various actions based on command entered
		# ------------------------------------------------

		# Break up array
		command = command_arr[0]
		details = command_arr[1..-1]

		if command == nil
			puts "You must enter a command for queue."
		elsif command == "count"
			count = @the_queue.to_a.size
			puts "The queue contains #{count} records."
		elsif command == "clear"
			@the_queue = []	
			puts "The queue was successfully cleared."
		elsif command == "print" and details[0] == "by"
			#Print by attribute
			clone_queue = @the_queue # Create clone of the_queue so that data remains intact
			attribute = details[1]
			if valid_header(attribute)
				clone_queue = clone_queue.sort_by { |row| row[:"#{attribute}"]}
				print_row_headers
				print_queue(clone_queue)
			end
		elsif command == "print"
			print_row_headers
			print_queue(@the_queue)
		elsif command == "save" && details[0] == "to"
			save_queue(details)
		end
		
	end

	def find(params)
		if params.size != 2
			puts "Find needs to be written as such: find <attribute> <criteria>"
		end
		attribute = params[0]
		criteria = params[1..-1] # Criteria can be a multi-word name or city i.e. "John Paul"
		count = 0
		if valid_header(attribute)
			@loaded_data.each do |row|
				# puts "|#{row[:"#{attribute}"].split.join(" ")}| vs |#{criteria.join(" ")}|"
				if row[:"#{attribute}"].split.join(" ").casecmp(criteria.join(" ")).zero?
					@the_queue << row
					count += 1
				end
			end
			puts "#{count} entries were added."
		end
		
	end
end

#-----------------------------------------------------------------------------------

reporter = EventReporter.new
reporter.run
