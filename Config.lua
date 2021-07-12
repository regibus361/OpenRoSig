return {
	Organisation = {
		Folders = {
			Signals = workspace.signalling.signals
		},
		
		Names = {
			SignalLower = 'Lower',
			SignalUpper = 'Upper',
			TrainHitter = 'SignalTriggerPart', -- At least one at the front and one at the back.
			SignalDetector = 'SignalDetector'
		}
	},
	
	
	
	Reservation = {
		BlocksAhead = 3 -- Should be at least #States - 1 for all states to be used
	},
	
	
	
	States = {
		-- The first one is the top color, the second one is the bottom color.
		-- Light will not be emitted for 0, 0, 0
		
		-- The states are ordered from least permissive (red) to most (green)
		{ Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 0, 0) },
		{ Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 0) },
		{ Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 0) },
		{ Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 255, 0) }
	},
	
	NewLight = function(Parent)
		-- Returns a light parented to the parent
		local Light = Instance.new('PointLight')
		Light.Brightness = 2
		Light.Range = 20
		Light.Parent = Parent
		return Light
	end,
}
