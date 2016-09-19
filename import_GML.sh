#!/bin/bash

if [ ! -d ${HOME}/ZIP ]
then
  mkdir ${HOME}/ZIP
fi

if [ ! -d ${HOME}/GML ]
then
  mkdir ${HOME}/GML
fi

echo "#### Paste HTML(http://nlftp.mlit.go.jp/ksj/gml/cgi-bin/download.php) to console and Type ^D"
rm -f ${HOME}/ZIP/*.zip
./import_GML1.rb | (cd ${HOME}/ZIP; wget -i - -q)

pushd ${HOME}/ZIP
for f in P20-12_??_GML.zip
do
  echo "#### $f"
  GML=`echo $f | sed -e 's/_GML\.zip//'`
  unzip -p $f ${GML}.xml 1>${HOME}/GML/${GML}.xml 2>/dev/null
  if [ $? != 0 ]
  then
    unzip -p $f ${GML}_GML/${GML}.xml 1>${HOME}/GML/${GML}.xml 2>/dev/null
  fi
done

popd
./import_GML2.rb ${HOME}/GML/*.xml
