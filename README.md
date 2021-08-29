# REKON.SH

## Rekon.sh is a bash script for automating initial recon tasks on given domain. It will find subdomains, probe for alive subdomains, take screenshots, dig dns info and perform bunch of other tasks to assit pentesters with further testing

## Right now the script includes:

* dig (for dns info)
* certspotter, crt.sh, subfinder, assetfinder (for getting subdomains)
* alive domains - httprobe
* screenshot - gowitness
* subdomain takeover - subjack
* crawl - hakrawler
* fetch params - paramfinder, separate with gf
* find links/api endpoints in js files - linkfinder
* pastebins

## I would like to implement:

* Read API Tokens from config.json
* nmap, shodan, breach-parse, amass
* Some more dns tools, maybe automate testing for zone transfers
* Maybe some CMS scanners like wpscan or droopescan in case a CMS is detected
