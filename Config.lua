return {
	Organisation = {
		Folders = {
			Signals = workspace.signalling.signals
		},
		
		Names = {
			SignalLower = 'Lower',
			SignalUpper = 'Upper',
			TrainHitter = 'SignalTriggerPart', -- At least one at the front and one at the back.
			SignalDetector = 'SignalDetector',
			AWSDetector = 'AWSMagnet'
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
	
	AWS = {
		DetectionDebounce = 15, -- More detections on one detector within this time period will not fire
		
		KeypressEvent = game.ReplicatedStorage.OpenRoSigKeypressEvent, -- Fire this on the client to deactivate!
		NotClearIsLooped = true, -- Whether to continue playing the 'not clear' sound until a key is pressed
		NotClearTimeout = 6, -- After this, the AWSTimedOut function is called. nil for no timeout
		
		ClearSoundID = 273295455, -- Example sounds by hhwheat, from roblox.com/library/1556802253
		NotClearSoundID = 273295334,
		SoundProperties = { Volume = 10, RollOffMaxDistance = 25 }, -- Additional properties to apply.
		
		GetPlayer = function(Hitter) -- Player driving the train. Can return nil
			return Hitter.Parent.DCCProperties.CurrentPlayer.Value
		end,
		
		GetSoundEminator = function(Hitter)
			return Hitter.Parent.Base
		end,
		
		TimedOut = function(Hitter)
			warn('You took too long!')
		end,
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
