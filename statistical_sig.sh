#!/bin/sh
cd reviews_folder
#echo "$PWD"
cp /dev/null stats_results.csv
echo "Filename,Mean,Var,SD,N" >> stats_results.csv
files=("$1" "$2")
for i in ${files[@]}
do
	awk ' 
	BEGIN{
		FS = ">";
		hotel_Ratings[""]=0;
		diffs_Squared[""]=0;
		count = 0;
		total = 0;
		diffs_Total = 0;
		mean = 0;
		sd = 0;
		var = 0;
	}
	{
		if ($1 == "<Overall") {
			hotel_Ratings[count]+=$2;
			#print "count: " count " value: " hotel_Ratings[count]; 
			count++;
		}
	}
	
	END{
		for (i in hotel_Ratings){
			total += hotel_Ratings[i];
		}
		mean = total/count;
		for (i in hotel_Ratings){
			diffs_Squared[i] = (hotel_Ratings[i] - mean)^2;
			diffs_Total += diffs_Squared[i];
		}
		if (count > 1){
			var = diffs_Total/(count - 1);
		}
		sd = sqrt(var);
		n = split(FILENAME,a,"/");
		n = split(a[n],b,".");
		print  b[1] "," mean "," var "," sd "," count >> "stats_results.csv";  
	}'  "$i"
done

cp /dev/null tResults.txt
awk '
	BEGIN{	
		FS = ",";
		t = 0;
		df = 0;
		mean1 = 0;
		mean2 = 0;
		var1 = 0;
		var2 = 0;
		n1 = 0;
		n2 = 0;
		gSD = 0;
	}
	{
		if (NR == 2){
			mean1 = $2;
			var1 = $3;
			n1 = $5;
		}
		if (NR == 3){
			mean2 = $2;
			var2 = $3;
			n2 = $5;
		}
	}
	END{
		df = (n1+n2-2);
		gSD = sqrt( ((n1-1)*var1+(n2-1)*var2)/df );
		t = ( (mean1 - mean2)/(gSD*sqrt((1/n1)+(1/n2))) ) ;
		print "t: " t;
		print t "," df  >> "tResults.txt";
	}
' stats_results.csv

awk '
	BEGIN{FS = ","}
	{
		if(NR >= 2){
			print "Mean " $1 ": " $2 ", SD: " $4;
		}
	}
	END{}
' stats_results.csv

awk '
	BEGIN{
		FS=",";
		# For df = 449, at 5% uncertainty, one tailed
		tCrit=1.648
		t = 0;
	}
	{
		if(NR = 1) t = $1;
	}
	END{
		if(t > tCrit){
			print "1";
		}
		else{
			print "0";
		}
	}
' "tResults.txt"
