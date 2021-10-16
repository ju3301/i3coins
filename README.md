# i3coins

Custom bar for i3 to get crypto prices in euros (€) 

next update => multi currency 

## Installation
    git clone https://github.com/ju3301/i3coins.git ~/.i3/i3coins
Then add the following code to your ```.i3/config``` :

    bar {
	status_command exec ~/.i3/i3coins/i3coins.sh
	position bottom
        tray_output none
        workspace_buttons no

        colors {
    		background #282A36
        }
    }