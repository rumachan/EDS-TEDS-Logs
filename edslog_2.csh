#!/bin/csh -f
#edslog.csh
#display recent parts of eds log files on web page

#important directories
set base_dir = /home/volcano/sds
set eds_dir = NZ/EDS/LOG.D
set eds_file = NZ.EDS.02.LOG.D
set out_dir = /home/volcano/workdir/eds_2
set qm_dir = /usr/local/bin
set webdir = /home/volcano/output

set lockfile = /home/volcano/workdir/edslog_2.lock

if (-e $lockfile) then
	echo Another instance of this script is still running
	exit
endif

touch $lockfile

mkdir -p $out_dir
#use curent date
set date = `date -u +"%Y%m%d"`

#directory for mseed data
set data_dir = `date -d $date +"$base_dir/%Y/$eds_dir"`

#log for primary
#file name
set name = `date -d $date +"$eds_file.%Y.%j"`
set datafile = $data_dir/$name
#check exists
if (! -e $datafile) then
	echo datafile $datafile not found
	exit
endif

#convert log file to ascii and keep only system messages
$qm_dir/qlog -o $out_dir/log $datafile

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
\cp $out_dir/all500 $webdir/eds2_all500.txt

#last 500 messages trigger
\cp $out_dir/trigger500 $out_dir/temp
cat $out_dir/trigger >> $out_dir/temp
sort -r $out_dir/temp | uniq >! $out_dir/temp2
head -500 $out_dir/temp2 >! $out_dir/trigger500
\rm $out_dir/temp $out_dir/temp2
#web page
\cp $out_dir/trigger500 $webdir/eds2_trigger500.txt

#last 500 messages noisy
\cp $out_dir/noisy500 $out_dir/temp
cat $out_dir/noisy >> $out_dir/temp
sort -r $out_dir/temp | uniq >! $out_dir/temp2
head -500 $out_dir/temp2 >! $out_dir/noisy500
\rm $out_dir/temp $out_dir/temp2
#web page
\cp $out_dir/noisy500 $webdir/eds2_noisy500.txt
rm $lockfile
