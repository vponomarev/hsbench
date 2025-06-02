#!/bin/sh

BUILD_TIME=$(date +"%Y%m%d-%H%M%S")
BUILD_DATE=$(date +"%Y%m%d")
CommitHash=N/A
GoVersion=N/A
GitTag=N/A

if [[ $(go version) =~ [0-9]+\.[0-9]+\.[0-9]+ ]];
then
    GoVersion=${BASH_REMATCH[0]}
fi

GV=$(git tag || echo 'N/A')
if [[ $GV =~ [^[:space:]]+ ]];
then
    GitTag=${BASH_REMATCH[0]}
fi

GH=$(git log -1 --pretty=format:%h || echo 'N/A')
if [[ GH =~ 'fatal' ]];
then
    CommitHash=N/A
else
    CommitHash=$GH
fi

FLAG="-X main.BuildTime=$BUILD_TIME"
FLAG="$FLAG -X main.CommitHash=$CommitHash"
FLAG="$FLAG -X main.GoVersion=$GoVersion"
FLAG="$FLAG -X main.GitTag=$GitTag"

if [[ $1 =~ 'linux' ]]
then
    GOOS=linux GOARCH=amd64 go build -v -o hsbench -ldflags "${FLAG}" -o hsbench-linux-amd64-${BUILD_DATE}
else
    go build -v -o hsbench -ldflags "${FLAG}" -o hsbench-${BUILD_DATE}
fi
