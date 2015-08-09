#!/bin/sh
#
#

doc_dir=../doc
wfiles_dir=../worldfiles
resos="37.5 100 150 200 300 400 600 800 1600"
# resos="100"

for reso in $resos; do
   csv_file="${doc_dir}/opentoponl_bladen_${reso}pxkm.csv"
   out_dir="${wfiles_dir}/wfiles${reso}pixkm"

   echo "START: reso=$reso: args = $csv_file $out_dir"
   python csv2worldfiles.py $csv_file $out_dir
   echo "END: reso=$reso: args = $csv_file $out_dir"
done
