# pinging_them_softly
Part of a planned multi-part network reconnaissance suite. All scripts are custom-built
to minimize risk of detection, primarily through minimal packet transmission and transmission
randomization. Each script is intended to work either jointly, or individually. 
1.Host Discovery: soft_ping takes either a host or network address as input. It randomizes 
the order of pings, and randomly delays transmission for each packet. Finally, it generates
a spreadsheet of all hosts numbers, all timeouts, and all "up" hosts. This spreadsheet allows
for further analysis to be done with other scripts in the suite, or for visual analysis.
#Future feature: change from .xls format to csv format
2.Service Discovery: soft_cat takes a host or network and a port range as input, and performs
banner-grabbing to determine services and versions on each port. Because it only sends one packet,
soft_cat is a lower-risk alternative to common nmap commands. 
#Future feature: take .csv document as input with discovered hosts, allowing users to chain 
soft_ping and soft_cat (and future scripts!). 
