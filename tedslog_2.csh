#!/bin/csh -f
#tedslog_2.csh
#display recent parts of teds log files on web page

#important directories
set base_dir = /geonet/seismic/sds
set teds_dir = NZ/TEDS/LOG.D
set teds_file = NZ.TEDS.02.LOG.D
set out_dir = /home/sherburn/geonet/edsteds_log/teds_2
set web = volcano@volcano:/var/www/html/volcanoes/tongariro/tedslog_2

#use curent date
set date = `date -u +"%Y%m%d"`

#directory for mseed data
set data_dir = `date -d $date +"$base_dir/%Y/$teds_dir"`

#log file 
#file name
set name = `date -d $date +"$teds_file.%Y.%j"`
set datafile = $data_dir/$name
#check exists
if (! -e $datafile) then
	echo datafile $datafile not found
	exit
endif
#echo $datafile

#convert log file to ascii and keep only system messages
qlog -o $out_dir/log $datafile

#which log messages
#all
\cp $out_dir/log $out_dir/all
egrep "TRIGGER|DETECTION|ERUPTION" $out_dir/log >! $out_dir/trigger
grep "NOISY" $out_dir/log >! $out_dir/noisy

#last 500 messages all
\cp $out_dir/all500 $out_dir/temp
cat $out_dir/all >> $out_dir/temp
sort -r $out_dir/temp | uniq >! $out_dir/temp2
head -500 $out_dir/temp2 >! $out_dir/all500
\rm $out_dir/temp $out_dir/temp2
#web page
scp $out_dir/all500 $web/all500.txt

#last 500 messages trigger
\cp $out_dir/trigger500 $out_dir/temp
cat $out_dir/trigger >> $out_dir/temp
sort -r $out_dir/temp | uniq >! $out_dir/temp2
head -500 $out_dir/temp2 >! $out_dir/trigger500
\rm $out_dir/temp $out_dir/temp2
#web page
scp $out_dir/trigger500 $web/trigger500.txt

#last 500 messages noisy
\cp $out_dir/noisy500 $out_dir/temp
cat $out_dir/noisy >> $out_dir/temp
sort -r $out_dir/temp | uniq >! $out_dir/temp2
head -500 $out_dir/temp2 >! $out_dir/noisy500
\rm $out_dir/temp $out_dir/temp2
#web page
scp $out_dir/noisy500 $web/noisy500.txt
