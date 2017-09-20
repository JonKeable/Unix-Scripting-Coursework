#!/bin/sh
#The folder to operate in is specified by the first argument
path="${PWD}/$1"
cd $path
# Clears the file used to store results
cp /dev/null means.txt
#echo "$path"
for file in *.dat;
do
	awk ' 
	BEGIN{
		# Sets the field seperator to close chevron, and initialises variables
		FS = ">"; 
		hotel_Ratings[""]=0;
		count = 0;
		total = 0;
		mean = 0;
	}
	{
		# Adds all the overall ratings to an array, and counts how many ratings there are
		if ($1 == "<Overall") {
			hotel_Ratings[count]+=$2;
			count++;
		}
	}
	
	END{
		#sums the ratings, and calculates the mean by dividing by the number of ratings
		for (i in hotel_Ratings){
			total += hotel_Ratings[i];
		}
		mean = total/count;

		#prints results to a file for storage
		n=split(FILENAME,a,"/");
		n = split(a[n],b,".");
		print b[1] ": " mean >> "means.txt"
	}
	' "$PWD/$file" 
done

#sorts the reuslts and prints to standard out
sort -rn -k2 means.txt
