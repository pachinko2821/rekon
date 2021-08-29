# REKON.SH

## Rekon.sh is a bash script for automating initial recon tasks on given domain. It will find subdomains, probe for alive subdomains, take screenshots, dig dns info and perform bunch of other tasks to assit pentesters with further testing

## Right now the script includes:

* dig (for dns info)
* certspotter, crt.sh, subfinder, assetfinder (for getting subdomains)
* amass for subdomains and d3 graph
* alive domains - httprobe
* screenshot - gowitness
* subdomain takeover - subjack
* crawl - hakrawler
* fetch params - paramfinder, separate with gf
* find links/api endpoints in js files - linkfinder
* pastebins
* Reads API Tokens from rekon.config

## I would like to implement:

* nmap, shodan, breach-parse
* Some more dns tools, maybe automate testing for zone transfers
* Maybe some CMS scanners like wpscan or droopescan in case a CMS is detected

## Config file:

* You can add API Tokens in the config file like so:
```
certspotter_api="YOUR_API_TOKEN"
```
* As of now, the script only supports certspotter api, there are plans to add shodan
