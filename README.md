# qb-miniheists
3 simple mini heists for beginners. lets you configure the reward payments and random items you may get from doing a heist. 
i plan to add more heists to it. feel free to request one

Discord - https://discord.gg/3WYz3zaqG5

Uses the latest versions 

## Dependencies
```
-Qb-core 
-qb-menu 
-qb-target
-ps-ui found here https://github.com/Project-Sloth/ps-ui  (used for minigames)
```

## Add to qb-core/shared/items.lua
```
--miniheists
	["lab-usb"]                      = {["name"] = "lab-usb", 				        ["label"] = "USB Research", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "lab-usb.png", 		        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "A USB filled with loads of complicated numbers and letters... Big brain stuff!"},
	["mw-usb"]                       = {["name"] = "mw-usb", 				        ["label"] = "Top Secret Data", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "mw-usb.png", 			    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Contains some very lewd photos and a interesting statement from a high ranking official!"},
	['lab-samples'] 		         = {['name'] = 'lab-samples', 			  	   	['label'] = 'Research Samples', 	    ['weight'] = 500, 		['type'] = 'item', 		['image'] = 'lab-samples.png', 		   	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'some creepy samples!'},
	['lab-files'] 				     = {['name'] = 'lab-files', 			  	   	['label'] = 'Research Files', 			['weight'] = 500, 		['type'] = 'item', 		['image'] = 'lab-files.png', 		   	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'lots of big words in these!'},
	```
  
  ## Copy images from foler into qb-inventory/html/images folder
