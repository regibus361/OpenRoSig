Last Updated: 1.2.1 (14.07.2021)  
You can get this as a model on Roblox at: https://www.roblox.com/library/7084317546  
An uncopylocked example place is at: https://www.roblox.com/games/7089261697  


OpenRoSig is an open source, absolute block railway signalling system based on signalling in the UK.
It includes the following features:
- Advance signals (e.g. yellow the signal before red) with no limit to how many states you can have
- The ability to disable certain aspects on individual signals
- A reservation system where each block has a queue of trains reserving it (preventing trains cutting each other off)

For ease of use and optimisation, it also uses:
- No value objects, attributes or scripts in the physical signals, instead storing data in a module script
- Detectors in signals, not blocks, to make them easier to place and move
- Event-based programming with no polling, and pauses during processing to spread script activity over a longer period.


-- Quick Start --

Everything you should need to change is in the Config and SignalData modules.
Going through Config, you will need to set the values accordingly:

Set Organisation.Folders.Signals to one parent folder all signals are kept inside.
Subfolders etc. are allowed; the system only looks for a parent named for each signal somewhere within the descendants.
An example signal has been included to indicate its structure (note this came from a Ro-Scale test place, hence the size)
The Names.SignalLower, Names.SignalUpper and Names.SignalDetector can be changed in Config - the Model child isn't used by the system.
The SignalDetector should be on the track such that train hitters touch it.

You will then need to configure each signal in the SignalData module.
An example entry looks like:

	['AB01'] = {
		NextSignals = {'AB02, AB03'},
		Block = 'AB001',
		EnabledAspects = {true, true, true}
	},
	
AB01 is the name of the signal's topmost model (as 'ExampleSignal').
AB02 and AB03 are the names of other models that are 'after' this signal.
This effectively means that AB01's aspect is affected by that of AB02 and AB03 due to AB01 being an advance signal to them.
AB001 is just a name that does not correspond to an instance in the workspace.

You must also ensure that trains have touch parts with the name Names.TrainHitter.
There should be one at the front AND back of every train - there can be more, however.


-- Code Documentation --

workspace.DescendantAdded is connected to the NewPart function that adds a touch event to every train hitter (by name + is base part)
The touch event checks if the other part is a signal detector, and if so, calls the DetectorTouched function.
Workspace descendants are then iterated through calling the NewPart function.

Signals are then checked, and if a descendant of the signal folder matches a name in the SignalData module, it is initialised.
A reference back to the model is added, as well as to its two lights.
The signals in the table are then checked through (an error is thrown if one wasn't found earlier).
They are all set to the lowest aspect to start, and have a PrevSignals array filled to supplement the NextSignals one.
Blocks are also set up whilst doing this, and afterwards they are all updated a few times to get the signals off red.

Note that all functions are called with and return the names of blocks and signals, not the actual tables.
This (might) save on overheads? It's easier to do this consistently, as names are stored in the tables themselves.
Storing references to tables within other tables causes the tables to loop forever, causing issues e.g. with print debugging.

When DetectorTouched is called, it effectively checks if the hitter that did it caused its train to enter or leave a block.
The best way of checking this is to simply check if a block that was empty is now full, or vice versa.
For both full and empty blocks, BlockChanged is called, which sets signals protecting that block accordingly.
If the block is full, they are set to the lowest state; if empty, they are checked individually based on other factors.
Each signal then iterates through the signals before it setting advance signals.

When entering a block, the system reserves the next few blocks - how many is defined by Config.Reservation.BlocksAhead.
It does this by getting the next few signals that could be passed from the GetNextSignals function.
Note that only blocks one (and not more) signal was returned for are reserved.
This is because, at this point, it is impossible to tell which of those signals the train will enter the block through.
(Of course, you're welcome to change this if you use preset routes - this system assumes you don't)
You also unreserve the block you just entered when you enter it, as the reservation is no longer needed.
Waiting to leave the block means you don't know which signal you came into the block from i.e. reserved it from.

When leaving a block, the system unreserves any blocks we didn't go through but could've gone through if the line forked.
It uses the GetNextSignals function for this, then excludes the signal the hitter did pass through.

When a block is 'reserved' (or unreserved), a signal and block are passed to the appropriate function.
The reservation is then added to a queue. If it is at the front of the queue, the ActivateReservation function is called.
Alternatively, the ActivateReservation function is also called if the reservation at the front of the queue is removed.
Reservations are automatically removed if a train is deleted (i.e. the hitter is parented out of workspace)

Train hitters also listen for AWS magnet hits. If they hit one, a sound object is created, parented to the sound eminator and played.
Depending on the signal's aspect (i.e. which type of AWS is played), a connection is created to destroy the sound.
This is either when a key is pressed (or the event is otherwise fired), or the sound ends.


-- Plugins --

OpenRoSig supports a primitive plugin system that effectively allows you to overwrite functions in the module.
Plugins are ModuleScripts inside the OpenRoSig.Plugins folder that have an attribute called Priority.
This attribute determines a plugin's priority level (lower number = higher priority) to prevent plugins fighting for control.
A plugin looks like this:

	-- This overwrites the 'Setup' function to print a value.
	local Plugin = {}

	Plugin.Setup = function()
		print('Just getting set up now.')
		Plugin.Setup_Base()
		print('I\'m all done setting up!')
	end

	return Plugin
	
Plugin.(function name goes here)\_Base is the generic function in the module. Therefore, this plugin still does all the setup.
If a plugin is higher priority than another plugin, its base function is the lower priority plugin's function.
For example, say I have a plugin with priority 1 and a plugin with priority 2 accessing the function ExampleFunction.
When ExampleFunction is called, it calls the function in the priority 1 plugin.
If that plugin references Plugin.ExampleFunction_Base, that calls the priority 2 plugin, not the 'real' base.
If the priority 2 plugin also references Plugin.ExampleFunction_Base, that then calls the 'real' base in the original script.
