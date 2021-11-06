#!/bin/bash

RED="\u001b[31m"
GREEN="\u001b[32m"
END="\u001b[0m"

source rekon.config

p=`python3 --version`
if [ -z "$p" ]
then
	echo -e "$RED[-]$END python is not installed! quitting..."
	exit 1
else
	echo -e "$GREEN[+]$END python version $p found!"
fi

g=`go version`
if [ -z "$g" ]
then
	echo -e "$RED[-]$END go is not installed! quitting..."
	exit 1
else
	echo -e "$GREEN[+]$END go version" $g "found!"
fi

# mkdir dependencies

# echo -e "$GREEN[+]$END Installing dependency Linkfinder"
# git submodule add https://github.com/GerbenJavado/LinkFinder dependencies/LinkFinder
# echo -e "$GREEN[+]$END Installing dependency ParamSpider"
# git submodule add https://github.com/devanshbatham/ParamSpider dependencies/Paramspider
# echo -e "$GREEN[+]$END Installing dependency Degoogle_Hunter"
# git submodule add https://github.com/six2dez/degoogle_hunter dependencies/degoogle_hunter

echo -e "$GREEN[+]$END Installing dependency subfinder"
go install github.com/projectdiscovery/subfinder@latest
echo -e "$GREEN[+]$END Installing dependency assetfinder"
go install github.com/tomnomnom/assetfinder@latest
echo -e "$GREEN[+]$END Installing dependency httprobe"
go install github.com/tomnomnom/httprobe@latest
echo -e "$GREEN[+]$END Installing dependency gowitness"
go install github.com/sensepost/gowitness@latest
echo -e "$GREEN[+]$END Installing dependency subjack"
go install github.com/haccer/subjack@latest
echo -e "$GREEN[+]$END Installing dependency hakrawler"
go install github.com/hakluke/hakrawler@latest
echo -e "$GREEN[+]$END Installing dependency gf"
go install github.com/tomnomnom/gf@latest

echo -e "$GREEN[+]$END Getting patterns for gf"
git clone https://github.com/1ndianl33t/Gf-Patterns
mkdir ~/.gf
mv Gf-Patterns/*.json ~/.gf
rm -rf Gf-Patterns

echo -e "$GREEN[+]$END Installing dependencies jq and amass, needs sudo permissions since it is installed via apt"
sudo apt install jq
sudo snap install amass

echo -e "$GREEN[+]$END Initializing shodan"
shodan init $shodan_api

echo -e "$GREEN[+]$END Creating symlink for rekon.sh in /usr/bin"
#sudo ln -rs rekon.sh /usr/bin

echo -e "$GREEN[+]$END Install successful!"