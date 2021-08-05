#!/bin/bash
ALL_OPT=$*
NEED_REBUILD=0

if [[ $1 == '--rewrite--manifest' ]] || [[ $1 == '--r' ]]  ; then
   NEED_REBUILD=1
 elif [[ $2 == '--rewrite--manifest' ]] || [[ $2 == '--r' ]]  ; then
   NEED_REBUILD=1
fi

rebuildManifest() {
 if [[ $NEED_REBUILD == 1 ]] ; then
   buildManifest
 fi
}


buildManifest() {
 ARCHIVE_JAR='ArchiveManifest.jar'
 java -jar $ARCHIVE_JAR $ALL_OPT
 ret=$?
 if [[ $ret == 0 ]] ; then
     echo 'rebuild manifest success'
 else
     echo 'rebuild manifest fail, log in logs/archive.log'
 fi
 return ret
}

checkPath(){
  path='output-directory/database'
  flag=1
  for p in ${ALL_OPT}
  do
     if [[ $flag == 0 ]] ; then
      path=`echo $p`
      break
     fi
     if [[ $p == '-d' || $p == '--database-directory' ]] ; then
      path=''
      flag=0
     fi
  done

  if [[ -z "${path}" ]]; then
     echo '-d /path or --database-directory /path'
     return 1
  fi

  if [[ -d ${path} ]]; then
    return 0
  else
    echo $path 'not exist'
    return 1
  fi
}

checkPath
if [[ 0 ==  $? ]] ; then
 rebuildManifest
else
 exit -1
fi
