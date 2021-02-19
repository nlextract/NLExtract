#!/bin/bash
#
# Test nested vsizip
#
# Just van den Broecke
#
# 0221 is Doesburg
# ogrinfo
# outer: BAGGEM0221L-15092020.zip
# inner: 0221GEM15092020.zip
# inner-inner: 0221PND15092020.zip
# content:  0221PND15092020-000001.xml

# source: https://extracten.bag.kadaster.nl/lvbag/extracten/Gemeente%20LVC/0221/BAGGEM0221L-15022021.zip
# ogrinfo /vsizip{/vsizip/{/vsizip/{BAGGEM0221L-15092020.zip}/0221GEM15092020.zip}/0221PND15092020.zip}
BAG_URL="https://extracten.bag.kadaster.nl/lvbag/extracten"
DATE="15022021"
GEM_CODE="0221"
BAG_ZIP="BAGGEM${GEM_CODE}L-${DATE}.zip"
BAG_ZIP_URL="${BAG_URL}/Gemeente%20LVC/${GEM_CODE}/${BAG_ZIP}"

echo "Download ${BAG_ZIP}"
curl --silent -o ${BAG_ZIP} ${BAG_ZIP_URL}

OBJS="LIG NUM OPR PND STA VBO WPL"
for OBJ in ${OBJS}
do
	# /vsizip/{/vsizip/{/vsizip/{BAGGEM0221L-15022021.zip}/0221GEM15022021.zip}/0221PND15022021.zip}
	ogrinfo /vsizip/{/vsizip/{/vsizip/${BAG_ZIP}/${GEM_CODE}GEM${DATE}.zip}/${GEM_CODE}${OBJ}${DATE}.zip}
done

# Test single file access
ogrinfo /vsizip/{/vsizip/{/vsizip/BAGGEM0221L-15022021.zip/0221GEM15022021.zip}/0221WPL15022021.zip}/0221WPL15022021-000001.xml

# /bin/rm ${BAG_ZIP}


# ogrinfo /vsizip/{/vsizip/{/vsizip/{BAGGEM0221L-15022021.zip}/0221GEM15022021.zip}/0221PND15022021.zip}
# V="08112020"
# OBJS="LIG NUM OPR PND STA VBO WPL"
# OBJS="LIG STA WPL"
# for OBJ in ${OBJS}
# do
# 	ogrinfo /vsizip/{/vsizip/{BAGNLDL-${V}.zip}/9999${OBJ}${V}.zip}
# done
#

