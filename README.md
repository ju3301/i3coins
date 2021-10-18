# i3coins

Custom bar for i3 to get crypto prices

## Required :

- python
- jq

## Next update :
    
- Add and Remove symbol for currency which not have one

## Installation :

    git clone https://github.com/ju3301/i3coins.git ~/.i3/i3coins

Then add the following code to your `.i3/config`, the script `i3coins.sh` require `-c currency` and `-d days`:

    bar {
	status_command exec ~/.i3/i3coins/i3coins.sh -c eur -d 1 #Currency and Days (Days should be 1|7|14|28|...|365)
	position bottom
        tray_output none
        workspace_buttons no

        colors {
    		background #282A36
        }
    }

# Usage : 

- Add crypto to list        `./i3coins.sh -a`

- Remove crypto to list     `./i3coins.sh -r`