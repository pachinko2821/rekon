# REKON.SH

## Rekon.sh is a bash script for automating initial recon tasks on given domain. It will find subdomains, probe for alive subdomains, take screenshots, dig dns info and perform bunch of other tasks to assit pentesters with further testing

## Dependencies

* You should have python3 and golang preinstalled
* Depends on the following go modules (need to have these preinstalled, I will include a script later on to install these automatically):
    * subfinder
    * assetfinder
    * amass
    * httprobe
    * gowitness
    * subjack
    * hakrawler
    * gf

## Right now the script includes:

* dig (for dns info)
* [certspotter](https://github.com/SSLMate/certspotter), [crt.sh](https://crt.sh/), [subfinder](https://github.com/projectdiscovery/subfinder), [assetfinder](https://github.com/tomnomnom/assetfinder) (for discovering subdomains)
* [amass](https://github.com/OWASP/Amass) for subdomains and d3 graph
* alive domains - [httprobe](https://github.com/tomnomnom/httprobe)
* screenshot - [gowitness](https://github.com/sensepost/gowitness)
* subdomain takeover - [subjack](https://github.com/haccer/subjack)
* crawl - [hakrawler](https://github.com/hakluke/hakrawler)
* fetch params - [paramspider](https://github.com/devanshbatham/ParamSpider), separate with [gf](https://github.com/tomnomnom/gf) and [gf-patterns](https://github.com/1ndianl33t/Gf-Patterns)
* find links/api endpoints in js files - [linkfinder](https://github.com/GerbenJavado/LinkFinder)
* Google Dorks - [degoogle_hunter](https://github.com/six2dez/degoogle_hunter)
* Reads API Tokens from rekon.config

## I would like to implement:

* nmap, shodan, breach-parse
* Some more dns tools, maybe automate testing for zone transfers
* Maybe some CMS scanners like wpscan or droopescan in case a CMS is detected
* waybackurls
* Add installer script

## Config file:

* You can add API Tokens in the config file like so:
```
certspotter_api="YOUR_API_TOKEN"
shodan_api="YOUR_API_TOKEN"
```
* As of now, the script only supports certspotter api, there are plans to add shodan

## 25resolvers.txt

* Run dnsvalidator and generate a list of public dns resolvers, randomly pick 25 of them. Works well with amass