# devnest

## gdoc
 https://docs.google.com/document/d/1a89J63e1S_-cFy7zvrMAYiVBgL-63cmCzQ2qBJvHnXk/edit#heading=h.yltg7mdy3hry

## imp commands

source ~/VENV/new-devnest-virtenv/bin/activate

List of available boxes68 
$ devnest list -g DFG
$ devnest list -g compute
$ devnest list -g network
$ devnest list -g storage

Reserving node for number of HOURS
$ devnest reserve -g DFG -t HOURS NODE_NAME
$ devnest reserve -g storage -t 48 shark19
$ devnest reserve -g compute --force -t 48 shark12 #See below info

Extend reservation
#One should not reserve node for too long time. If you need to keep it for longer try to reserve for minimum required and if necessary extend reservation (example to extend by 8 hours):
$ devnest extend -t 8 shark19

Release :
devnest release shark3

# upgrade from rhel8 to rhel9

https://docs.google.com/document/d/1Q8Wn3V0WtYMIADK6I5MWZ2tG-2MzA_K53vkmNtw3Y_Y/edit?usp=sharing

