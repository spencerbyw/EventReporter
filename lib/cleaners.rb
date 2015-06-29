def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phone_number(phone_number)
	clean_phone = phone_number.gsub(/[^\d]/, '')
	if clean_phone.length < 10
		clean_phone = "0000000000"
	elsif clean_phone.length == 11
		if clean_phone[0] == "1"
			clean_phone = clean_phone[1..10]
		else
			clean_phone = "0000000000"
		end
	elsif clean_phone.length > 11
		clean_phone = "0000000000"
	else
		clean_phone
	end

	clean_phone.insert(6, '-')
	clean_phone.insert(3, '-')
end
