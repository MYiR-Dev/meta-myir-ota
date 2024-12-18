#/bin/bash
#To disable bootcount, "accepted" entry has to be true in metadata (in order to leave trial mode)
#This is done in st-boot-script.sh called by rauc just after

/usr/bin/rauc status mark-good
