#!/usr/bin/env bash

TOKEN=""
PROBLEM_ID=""

# 不要编辑以下内容
FILE="/tmp/upload.tar.bz2"
URL="39.101.140.145"
GET=false
ERR=false
while getopts ":dp" opt; do
    case $opt in
        d)
        URL="127.0.0.1"
        ;;
        p)
        GET=true
        ;;
        \?)
        echo "非法参数：-$OPTARG"
        ERR=true
        ;;
    esac
done

if [ "$ERR" = true ]; then
    return
fi

echo "远程地址: $URL"
echo "返回结果："

if [ "$GET" = true ]; then
    curl http://$URL:10140/api/getProblemData?type=brief
else
    tar -cf "$FILE" --exclude=".git" \
                    --exclude="submit.sh" \
                    --exclude="LICENSE" \
                    --exclude="README*" "./"

    curl -F "token=$TOKEN" \
         -F "problemId=$PROBLEM_ID" \
         -F "upload=@$FILE" \
        http://$URL:10140/api/uploadFileByScript
fi
