#/bin/bash

FILENAME="definitions.txt"

echo -e "Welcome to the Simple converter!"

function check_definition() {

echo "Enter a definition:"

read -a user_input
length="${#user_input[@]}"
definition="${user_input[0]}"
constant="${user_input[1]}"
re1='^[a-z]*_to_[a-z]*$'
re2='^[+-]?[0-9]+([.][0-9]+)?$'

if [[ $length == "2" ]] && [[ "$definition" =~ $re1 ]] && [[ "$constant" =~ $re2 ]]; then
    echo "$definition $constant" >> $FILENAME
else 
    echo "The definition is incorrect!"
    check_definition
fi
}

function delete_definition() {

if [ -s $FILENAME ]; then
    lines_count="$(wc -l $FILENAME | cut -d ' ' -f 1)"
    echo "Type the line number to delete or '0' to return"
    nl -n 'ln' -s '. ' -w 1 $FILENAME
    
    while true
        do
            read line_number
            case "$line_number" in
                0 ) 
                    break;;
                [1-"$lines_count"] ) 
                    sed -i "${line_number}d" "$FILENAME" 
                    break;;
                * )
                    echo "Enter a valid line number!"
                    continue;;
            esac
        done
    else
        echo "Please add a definition first!"
fi
}

function convert_units() {

    if [ -s $FILENAME ]; then
        lines_count="$(wc -l $FILENAME | cut -d ' ' -f 1)"
        echo "Type the line number to convert units or '0' to return"
        nl -n 'ln' -s '. ' -w 1 $FILENAME

        while true
            do
                read line_number
                case "$line_number" in
                    0 ) 
                        break;;
                    [1-"$lines_count"] ) 
                        echo "Enter a value to convert:"
                        read value
                        while ! [[ "$value" =~ $re2 ]];               
                        do
                            echo "Enter a float or integer value!"
                            read value
                        done
                            echo "Line number: $line_number"
                            argument=`sed "${line_number}q;d" $FILENAME | cut -d " " -f 2`
                            echo "Argument: $argument"
                            result=`echo "scale = 1; $value * $argument" | bc`
                            echo "Result: $result"
                        break;;
                    * )
                        echo "Enter a valid line number!"
                        continue;;
                esac
            done
        else
            echo "Please add a definition first!"
            return 0
        fi
}

while true
    do
        echo -e "\nSelect an option"
        echo "0. Type '0' or 'quit' to end program"
        echo "1. Convert units"
        echo "2. Add a definition"
        echo "3. Delete a definition"

        read -a user_input
        case $user_input in
            "0" | "quit" )
                echo "Goodbye!"
                break;;
            "1" )
                convert_units
                continue;; 
            "2" )
                check_definition
                continue;;
            "3" )
                delete_definition
                continue;;
            * )
                echo "Invalid option!"
                continue;;
        esac
    done