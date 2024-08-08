echo "Enter a definition:"
read -a user_input

length="${#user_input[@]}"
definition="${user_input[0]}"
constant="${user_input[1]}"

re1='^[a-z]*_to_[a-z]*$'
re2='^[+-]?[0-9]+([.][0-9]+)?$'



if [[ $length == "2" ]] && [[ "$definition" =~ $re1 ]] && [[ "$constant" =~ $re2 ]]; then
	echo "Enter a value to convert:"
	read value
	while ! [[ "$value" =~ $re2 ]]; 
		do 	
			echo "Enter a float or integer value!"
			read value
		done
	result=$(echo "scale=2; $constant * $value" | bc -l)
	printf "Result: %s\n" "$result"
	
else 
	echo "The definition is incorrect!"
fi


