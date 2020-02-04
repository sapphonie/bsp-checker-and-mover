#!/bin/bash
#
# script for verifying if a file is a bsp file
# and moving it to my fast dl directory accordingly
#
# checks if file is
#   a) not in use
#   b) has the bsp suffix
#   c) is a valid bsp file

# prevent directory from getting expanded by the glob char if no files are present
shopt -s nullglob
# iterate thru files in this directory
for file in /home/sigafoo/PutMapsHereForFastDL/* /home/newbie/PutMapsHereForFastDL/* ;
do
    # is thefile in use?
    fuser $file &> /dev/null ;
    if [ $? != 0 ]
    # file is not in use
    then
        # does file have the bsp suffix?
        if [[ $file == *".bsp" ]]
        # file does have the bsp suffix
        then
            # does file have the bsp header?
            hexdump -n 8 $file | grep "4256 5053 0014 0000" &> /dev/null ;
            if [ $? == 0 ]
            # file is almost certainly a real bsp file
            then
                echo $file;
                cp -fv $file /var/www/steph.anie.dev/files/tf/maps/ &&
                sleep .1 &&
                rm -fv $file;
            # file does have the bsp suffix but contains invalid data
            else
                echo "$file is the wrong format";
                rm $file;
            fi
        # file does not have the bsp suffix
        else
            echo "$file is not a BSP file";
            rm $file;
        fi
    else
        echo "Not moving $file, in use";
    fi
done
