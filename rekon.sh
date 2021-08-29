#!/bin/bash

# dig
# certspotter, crt.sh, subfinder, assetfinder
# alive domains - httprobe
# screenshot - aquatone/gowitness
# subdomain takeover - subjack
# crawl - hakrawler
# fetch params - paramfinder, separate with gf
# find links/api endpoints in js files - linkfinder

# nmap, shodan, check pastebins, breach-parse

function print_banner {
	echo '4paI4paI4paI4paI4paI4paI4pWX4paR4paI4paI4paI4paI4paI4paI4paI4pWX4paI4paI4pWX
4paR4paR4paI4paI4pWX4paR4paI4paI4paI4paI4paI4pWX4paR4paI4paI4paI4pWX4paR4paR
4paI4paI4pWXCg=='|base64 -d
	echo '4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWQ4pWQ4pWd4paI4paI4pWR
4paR4paI4paI4pWU4pWd4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4paI4paI4pWX4paR
4paI4paI4pWRCg=='|base64 -d
	echo '4paI4paI4paI4paI4paI4paI4pWU4pWd4paI4paI4paI4paI4paI4pWX4paR4paR4paI4paI4paI
4paI4paI4pWQ4pWd4paR4paI4paI4pWR4paR4paR4paI4paI4pWR4paI4paI4pWU4paI4paI4pWX
4paI4paI4pWRCg=='|base64 -d
	echo '4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWd4paR4paR4paI4paI4pWU
4pWQ4paI4paI4pWX4paR4paI4paI4pWR4paR4paR4paI4paI4pWR4paI4paI4pWR4pWa4paI4paI
4paI4paI4pWRCg=='|base64 -d
	echo '4paI4paI4pWR4paR4paR4paI4paI4pWR4paI4paI4paI4paI4paI4paI4paI4pWX4paI4paI4pWR
4paR4pWa4paI4paI4pWX4pWa4paI4paI4paI4paI4paI4pWU4pWd4paI4paI4pWR4paR4pWa4paI
4paI4paI4pWRCg=='|base64 -d
	echo '4pWa4pWQ4pWd4paR4paR4pWa4pWQ4pWd4pWa4pWQ4pWQ4pWQ4pWQ4pWQ4pWQ4pWd4pWa4pWQ4pWd
4paR4paR4pWa4pWQ4pWd4paR4pWa4pWQ4pWQ4pWQ4pWQ4pWd4paR4pWa4pWQ4pWd4paR4paR4pWa
4pWQ4pWQ4pWdCg=='|base64 -d
}

function print_usage {	
	echo -e "\nUsage:\n-d|--domain <domain> to specify domain"
}

if [ $# -eq 0 ]; then
	print_banner
	print_usage
	exit 1
fi

RED="\u001b[31m"
YELLOW="\u001b[33m"
GREEN="\u001b[32m"
END="\u001b[0m"

while test $# -gt 0; do
	case "$1" in
		-h|--help)
			print_banner
			print_usage
			exit 0
			;;

		-d|--domain)
			shift
			domain=$1
			break
			;;
		*)
			print_banner
			print_usage
			exit 1
			;;
	esac
done

# DNS info
print_banner

echo -e "\n$GREEN[+]$END Target: $domain"

mkdir $domain
cd $domain
mkdir dns
cd ../

echo -e "\n$YELLOW[!]$END Digging DNS info...."

## dig
dig $domain ANY > $domain/dns/dig.txt 
whois $domain > $domain/dns/whois.txt

echo -e "\n$GREEN[+]$END Done!"

echo -e "\n$YELLOW[!]$END Fetching subdomains...."

## certspotter
curl --silent -H "Authorization: Bearer xxxxxx" "https://api.certspotter.com/v1/issuances?domain=$domain&expand=dns_names&expand=issuer&expand=cert&include_subdomains=true" |jq -r '.[] | .dns_names |.[]' |sort -u >> $domain/dns/temp.txt

## crt.sh
curl --silent "https://crt.sh/?q=$domain" |grep -Eo "([a-zA-Z0-9]+\.)+[a-zA-Z0-9]+" |sort -u >> $domain/dns/temp.txt

## assetfinder
assetfinder $domain >> $domain/dns/temp.txt

cat $domain/dns/temp.txt |grep $domain |sort -u > $domain/dns/subdomains.txt
rm $domain/dns/temp.txt

echo -e "\n$GREEN[+]$END Done!"

echo -e "\n$YELLOW[!]$END Probing for alive subdomains...."
## httprobe
cat $domain/dns/subdomains.txt |httprobe >> $domain/dns/alive.txt

echo -e "\n$GREEN[+]$END Done!"
# WEB info 

cd $domain
mkdir web
cd web
mkdir screenshots
cd ../../

echo -e "\n$YELLOW[!]$END Taking screenshots of alive subdomains...."
## gowitness
gowitness -F --db-path $domain/web/gowitness.sqlite3 file -f $domain/dns/alive.txt --screenshot-path $domain/web/screenshots/ &>/dev/null
echo -e "\n$GREEN[+]$END Done!"

echo -e "\n$YELLOW[!]$END Crawling alive domains...."
# hakrawler
cat $domain/dns/alive.txt |hakrawler >> $domain/web/params/temp.txt
echo -e "\n$GREEN[+]$END Done!"

echo -e "\n$YELLOW[!]$END Mining Params"
# paramspider
/opt/ParamSpider/paramspider.py -q -d $domain -o $domain/web/params/spider.txt &>/dev/null
echo -e "\n$GREEN[+]$END Done!"

cat $domain/web/params/temp.txt >> $domain/web/params/spider.txt
rm $domain/web/params/temp.txt

# identify interesting params using gf
cat $domain/web/params/spider.txt |gf debug_logic >> $domain/web/params/debug.txt
cat $domain/web/params/spider.txt |gf idor >> $domain/web/params/idor.txt
cat $domain/web/params/spider.txt |gf img-traversal >> $domain/web/params/img-traversal.txt
cat $domain/web/params/spider.txt |gf interestingEXT >> $domain/web/params/extensions.txt
cat $domain/web/params/spider.txt |gf interestingparams >> $domain/web/params/params.txt
cat $domain/web/params/spider.txt |gf interestingsubs >> $domain/web/params/subs.txt
cat $domain/web/params/spider.txt |gf jsvar >> $domain/web/params/jsvariables.txt
cat $domain/web/params/spider.txt |gf lfi >> $domain/web/params/lfi.txt
cat $domain/web/params/spider.txt |gf rce >> $domain/web/params/rce.txt
cat $domain/web/params/spider.txt |gf redirect >> $domain/web/params/redirects.txt
cat $domain/web/params/spider.txt |gf sqli >> $domain/web/params/sqli.txt
cat $domain/web/params/spider.txt |gf ssrf >> $domain/web/params/ssrf.txt
cat $domain/web/params/spider.txt |gf ssti >> $domain/web/params/ssti.txt
cat $domain/web/params/spider.txt |gf xss >> $domain/web/params/xss.txt

# identify api endpoints in js files
for url in $(cat $domain/dns/alive.txt); do /opt/LinkFinder/linkfinder.py -d $url -o $domain/web/linkfinder.html &>/dev/null