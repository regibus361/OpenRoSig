-- NOTE that the standard is to pass/return signal and block NAMES, not tables, to/from functions. This shd save on overheads

-- Initial setup; all three of these are dictionaries
local Signals = require(script.SignalData)
local Config = require(script.Config)
local Blocks = {}
local Reservations = {} -- Sorted by hitter.

local RunService = game:GetService('RunService')



-- Functions --

local Functions = {}

-- Wait a bit between operations.
Functions.Wait2 = function()
	--RunService.Heartbeat:Wait()
end



-- Set a signal's state
Functions.SetState = function(SignalName, State)
	local Signal = Signals[SignalName]

	if Signal.State == State then
		return -- Not worth our time
	end

	Signal.State = State

	-- Now set its color
	local LowerColor = Config.States[State][1]
	local UpperColor = Config.States[State][2]

	Signal.Model[Config.Organisation.Names.SignalUpper].Color = LowerColor
	Signal.LowerLight.Enabled = LowerColor == Color3.new() -- If it's 0, 0, 0
	Signal.LowerLight.Color = LowerColor

	Signal.Model[Config.Organisation.Names.SignalLower].Color = UpperColor
	Signal.UpperLight.Enabled = UpperColor == Color3.new()
	Signal.UpperLight.Color = UpperColor
end



-- Check a signal's state
Functions.CheckState = function(SignalName)
	local Signal = Signals[SignalName]

	if Blocks[Signal.Block].HitterCount > 0 then
		return 1 -- Set to red unconditionally
	end

	local State = #Config.States -- Start at the highest state and go down through each next signal

	for _, NextSignal in ipairs(Signal.NextSignals) do -- Check every signal ahead for 'low' aspects requiring advance
		State = math.min(State, Signals[NextSignal].State + 1) -- It's still 1 more permissive
	end

	return State
end



-- Get the next signals or next blocks after a signal, a certain distance away.
-- This is a tree shape, but it doesn't return any 'tree' data structure, which is bad
-- (reserving shd only bother with the last layer, as the other layers shd already be reserved)
Functions.GetNextSignals = function() end
Functions.GetNextSignals = function(SignalName, Count, IncludeStarting)
	local NextSignals = IncludeStarting and { SignalName } or {}
	if Count == 0 then
		return NextSignals -- Not useful to do anything else.
	end

	local Signal = Signals[SignalName]

	for _, NextSignal in ipairs(Signal.NextSignals) do
		-- Add this signal, and its next signals (with 1 less count to prevent it going on forever)
		for _, NextSignal1 in ipairs(Functions.GetNextSignals(NextSignal, Count - 1, true)) do
			table.insert(NextSignals, NextSignal1)
		end
	end

	return NextSignals
end



-- When a signal changes, update advance aspects behind it.
Functions.UpdatePrevSignals = function() end -- Allow for recursion.
Functions.UpdatePrevSignals = function(SignalName)
	local Signal = Signals[SignalName]

	for _, PrevSignal in ipairs(Signal.PrevSignals) do
		local OldState = Signals[PrevSignal].State
		local NewState = Functions.CheckState(PrevSignal)

		-- Check if we're actually changing - if not, stop bothering
		if NewState ~= OldState then
			Functions.SetState(PrevSignal, NewState)
			Functions.UpdatePrevSignals(PrevSignal) -- Move it back one
		end
	end
end



-- Reserve and unreserve blocks.
Functions.ActivateReservation = function(BlockName)
	-- Fetch some variables
	local Block = Blocks[BlockName]
	local SignalName = Block.ReservationQueue[1] -- Reserve from the signal at the front of the queue

	if SignalName == nil then
		return -- Nothing to reserve (we're all caught up!)
	end

	for _, OtherSignalName in ipairs(Block.InSignals) do
		if OtherSignalName == SignalName then
			-- Make it as permissive as we can
			local NewState = Functions.CheckState(OtherSignalName)
			if NewState ~= Signals[OtherSignalName].State then
				Functions.SetState(OtherSignalName, NewState)
				Functions.UpdatePrevSignals(OtherSignalName)
			end
		else
			-- Set this signal to danger, as it's conflicting with our path
			Functions.SetState(OtherSignalName, 1)
			Functions.UpdatePrevSignals(OtherSignalName)
		end
	end
end



Functions.ReserveBlock = function(Hitter, BlockName, SignalName)
	local Block = Blocks[BlockName]

	-- Join the queue, if we're not already in it
	if table.find(Block.ReservationQueue, SignalName) ~= nil then
		return -- We're wasting time here
	end

	-- Otherwise, queue us up
	table.insert(Block.ReservationQueue, SignalName)
	Reservations[Hitter][BlockName] = SignalName

	-- If we're up the front, update the system to actually let us in.
	if #Block.ReservationQueue == 1 then
		Functions.ActivateReservation(BlockName)
	end
end



Functions.UnreserveBlock = function(Hitter, BlockName, SignalName)
	local Block = Blocks[BlockName]

	-- Unqueue this signal, if it's queued at all
	local SignalIndex = table.find(Block.ReservationQueue, SignalName)
	if SignalIndex ~= nil then
		table.remove(Block.ReservationQueue, SignalIndex)
		if SignalIndex == 1 then
			Functions.ActivateReservation(BlockName) -- The front was removed and thus changed
		end

		-- Update the Reservations table
		Reservations[Hitter][BlockName] = nil
	end
end



-- Main two functions: detect and act upon changes
Functions.BlockChanged = function(BlockName)
	local Block = Blocks[BlockName]

	if Block.HitterCount > 0 then
		-- This block is occupied: set its signals to danger
		for _, SignalName in ipairs(Block.InSignals) do
			Functions.SetState(SignalName, 1) -- 1 is the least permissive, NOT ZERO as in 2.4

			-- Now check for signals behind that need to be changed as well
			Functions.UpdatePrevSignals(SignalName)
		end
	else
		-- Free this block up
		for _, SignalName in ipairs(Block.InSignals) do
			-- Set the state based on what it should be
			Functions.SetState(SignalName, Functions.CheckState(SignalName))
			Functions.UpdatePrevSignals(SignalName)
		end
	end
end



Functions.DetectorTouched = function(Detector, Hitter, IsForward)
	-- We needn't check if it's a hitter, as only hitters are connected (see below)
	-- We needn't check that Detector is a detector either

	-- Change the part's current block, and update other block data
	local SignalName = Detector.Parent.Name -- This assumes detectors are directly parented to the signal!

	local OldBlockName = Hitter:GetAttribute('SignalBlock')
	local OldBlock = Blocks[OldBlockName]

	local NewBlockName
	local NewBlock

	-- Decide new block based on direction
	if IsForward == true then
		NewBlockName = Signals[SignalName].Block
		NewBlock = Blocks[NewBlockName]
	else
		-- Get the new block from the previous signal
		local PrevSignalName = Signals[SignalName].PrevSignals[1]
		if PrevSignalName ~= nil then -- If it's nil, our 'new block' doesn't exist!
			NewBlockName = Signals[PrevSignalName].Block
			NewBlock = Blocks[NewBlockName]
		end
	end
	
	if OldBlockName == NewBlockName then
		return
	end

	Hitter:SetAttribute('SignalBlock', NewBlockName)

	if OldBlock ~= nil then -- In case the train just spawned
		OldBlock.HitterCount -= 1 -- A hitter has left the block
		if OldBlock.HitterCount == 0 then
			-- The block has become empty
			Functions.BlockChanged(OldBlockName)
			Functions.Wait2()

			-- Don't unreserve the block we just left, as it was unreserved when we entered it
			-- Unreserve all blocks from signals we didn't go through
			for _, UnpassedSignalName in ipairs(OldBlock.OutSignals) do
				if UnpassedSignalName ~= SignalName then -- Don't unreserve the signal we did pass
					-- We need to find all the SIGNALS ahead of here, and then unreserve from them.
					-- BlocksAhead - 1 as we're one ahead of where we were, so didn't reserve quite that far
					for _, SignalName in ipairs(Functions.GetNextSignals(UnpassedSignalName, Config.Reservation.BlocksAhead - 1, true)) do
						Functions.UnreserveBlock(Hitter, Signals[SignalName].Block, SignalName) -- Unreserve this signal's block from the signal.
					end
				end
			end
		end
	end

	Functions.Wait2()

	if NewBlock ~= nil then
		NewBlock.HitterCount += 1 -- A hitter has entered the block
		if NewBlock.HitterCount == 1 then
			-- The block has just become full (it was 0 before)
			Functions.BlockChanged(NewBlockName)
			Functions.Wait2()

			-- Reserve blocks from this signal
			local NextSignals = Functions.GetNextSignals(SignalName, Config.Reservation.BlocksAhead, false)
			local ReservedBlocks = {} -- Dictionary!

			for _, SignalToReserve in ipairs(NextSignals) do
				local Block = Signals[SignalToReserve].Block
				if ReservedBlocks[Block] ~= nil then
					table.insert(ReservedBlocks[Block], SignalToReserve) -- It's full now anyway
				else
					ReservedBlocks[Block] = { SignalToReserve }
				end
			end

			-- Now, reserve every block with EXACTLY ONE signal
			for BlockToReserve, SignalsToReserve in pairs(ReservedBlocks) do
				if #SignalsToReserve == 1 then
					Functions.ReserveBlock(Hitter, BlockToReserve, SignalsToReserve[1]) -- Reserve it!
				end
			end

			Functions.Wait2()

			-- Unreserve the block we just entered (we don't need it reserved anymore)
			-- It's easiest to do this now, because we know which signal we had reserved from
			Functions.UnreserveBlock(Hitter, NewBlockName, SignalName)
		end
	end
end



-- The AWS system
Functions.AWSDetectorTouched = function(Detector, Hitter)
	-- Before anything else, check we're enabled and we're not on debounce
	if Config.AWS.GetAWSEnabled(Hitter) ~= true then -- On the off chance it returns nil
		return
	end
	
	if tick() - (Detector:GetAttribute('LastDetection') or 0) < Config.AWS.DetectionDebounce then
		Detector:SetAttribute('LastDetection', tick()) -- Maybe bad practice, but makes more sense for long trains with more cars
		return
	end

	Detector:SetAttribute('LastDetection', tick()) -- We still need to set it!

	-- Get its signal
	local SignalName = Detector.Parent.Name
	local Signal = Signals[SignalName]
	local State = Signals[SignalName].State

	if State == #Config.States then
		-- Clear - play ding
		local Eminator = Config.AWS.GetSoundEminator(Hitter)
		local Sound = Eminator:FindFirstChild('AWSClear')
		
		if Sound == nil then -- Create it if it doesn't already exist
			Sound = Instance.new('Sound')
			Sound.Name = 'AWSClear'
			Sound.Parent = Config.AWS.GetSoundEminator(Hitter)
			Sound.SoundId = 'rbxassetid://' .. tostring(Config.AWS.ClearSoundID)
		end
		
		Sound:Play()

		-- Destroy it when it's finished using a connection (could've used a coroutine)
		local Connection
		Connection = Sound.Ended:Connect(function()
			Connection:Disconnect() -- Clean it up
		end)
	else
		-- Not clear - play beep repeatedly until silenced
		local Eminator = Config.AWS.GetSoundEminator(Hitter)
		local Sound = Eminator:FindFirstChild('AWSNotClear')

		if Sound == nil then -- Create it if it doesn't already exist
			Sound = Instance.new('Sound')
			Sound.Name = 'AWSNotClear'
			Sound.Parent = Config.AWS.GetSoundEminator(Hitter)
			Sound.SoundId = 'rbxassetid://' .. tostring(Config.AWS.NotClearSoundID)
		end

		Sound:Play()

		if Config.AWS.NotClearIsLooped == true then
			Sound.Looped = true -- Loop it
			local Connection -- Connect its deletion to a keypress event
			local RequiredPlayer = Config.AWS.GetPlayer(Hitter)

			if RequiredPlayer ~= nil then
				local Pressed = false

				Connection = Config.AWS.KeypressEvent.OnServerEvent:Connect(function(Player, InputType)
					if Player == RequiredPlayer and InputType == 'AWS' then
						if Connection ~= nil then Connection:Disconnect() end -- idk why it's sometimes nil
						Sound:Stop()
						Pressed = true
					end
				end)

				-- Time out if needed
				if Config.AWS.NotClearTimeout ~= nil then
					delay(Config.AWS.NotClearTimeout, function()
						if Pressed == false then
							Config.AWS.TimedOut(Hitter)
							Connection:Disconnect()
							Sound:Stop()
						end
					end)
				end
			end
		else
			-- As above - sorry about code duplication
			local Connection
			Connection = Sound.Ended:Connect(function()
				Connection:Disconnect() -- Clean it up
				Sound:Stop()
			end)
		end
	end
end



-- Setup --

Functions.Setup = function()
	-- Connect train hitters to the above
	local IsForward = function(Detector, Hitter)
		local DetectorDirection = Detector.CFrame.LookVector
		local HitterDirection = Hitter.Velocity.Unit

		-- Check which is closer: the same direction or opposite direction
		local ForwardMagnitude = (DetectorDirection - HitterDirection).Magnitude
		local BackwardMagnitude = (DetectorDirection - (HitterDirection * -1)).Magnitude
		return ForwardMagnitude < BackwardMagnitude
	end

	local NewPart = function(Hitter)
		-- The second clause prevent welds named to the welded part being picked up.
		if Hitter.Name == Config.Organisation.Names.TrainHitter and Hitter:IsA('BasePart') then
			-- It's a hitter
			Hitter.TouchEnded:Connect(function(OtherPart) -- TouchEnded in case it drives onto one then back off it
				if OtherPart.Name == Config.Organisation.Names.SignalDetector then
					-- It's a detector, so call the above function
					Functions.DetectorTouched(OtherPart, Hitter, IsForward(OtherPart, Hitter))
				elseif OtherPart.Name == Config.Organisation.Names.AWSDetector then
					Functions.AWSDetectorTouched(OtherPart, Hitter)
				end
			end)

			-- Give it a reservations array
			Reservations[Hitter] = {}

			-- And listen for it being deleted
			local Connection = Hitter.AncestryChanged:Connect(function(Ancestor, NewParent)
				if Ancestor == Hitter and NewParent ~= workspace then
					-- It's been deleted - clear the array
					for BlockName, SignalName in pairs(Reservations[Hitter]) do
						Functions.UnreserveBlock(Hitter, BlockName, SignalName)
					end

					Reservations[Hitter] = nil -- We don't need this anymore

					-- Clear its block
					local BlockName = Hitter:GetAttribute('SignalBlock')
					local Block = Blocks[BlockName]
					if Block ~= nil then -- Otherwise, don't bother (it causes errors anyway)
						Block.HitterCount -= 1
						if Block.HitterCount == 0 then
							Functions.BlockChanged(BlockName)
						end
					end
				end
			end)
		end
	end

	workspace.DescendantAdded:Connect(NewPart)
	for _, Part in ipairs(workspace:GetDescendants()) do
		NewPart(Part) -- In case any were here before this ran
	end



	-- Set up blocks and signals
	-- Find the model for each signal
	for _, d in ipairs(Config.Organisation.Folders.Signals:GetDescendants()) do
		local Signal = Signals[d.Name]
		if Signal ~= nil then
			-- Set the model key
			Signal.Model = d

			-- Give it lights
			local Lower = d[Config.Organisation.Names.SignalLower]
			local Upper = d[Config.Organisation.Names.SignalUpper]

			Signal.LowerLight = Lower:FindFirstChildWhichIsA('Light') or Config.NewLight(Lower)
			Signal.UpperLight = Upper:FindFirstChildWhichIsA('Light') or Config.NewLight(Upper)
		end
	end



	for Name, Data in pairs(Signals) do
		-- Initialise the signal
		Functions.SetState(Name, 1) -- Initialise to red

		-- Fill in the Blocks table
		if Blocks[Data.Block] == nil then
			Blocks[Data.Block] = {
				HitterCount = 0, -- Number of hitters in the block
				InSignals = { Name }, -- Start listing all the signals
				OutSignals = {},
				ReservationQueue = {}
			}
		else
			table.insert(Blocks[Data.Block].InSignals, Name) -- Keep the above list up to date
		end

		-- Give it a PrevSignals table, if it hasn't already been given one by another signal
		Data.PrevSignals = Data.PrevSignals or {}

		-- Add to the PrevSignals array from every next signal
		for _, NextSignal in ipairs(Data.NextSignals) do
			-- PrevSignals in this signal (NextSignal) that should point back to us
			if Signals[NextSignal].PrevSignals ~= nil then -- In case it doesn't exist yet
				table.insert(Signals[NextSignal].PrevSignals, Name) -- Add us!
			else
				-- Create the table first
				Signals[NextSignal].PrevSignals = { Name }
			end

			-- Now, add this signal to the OutSignals of our block - if it's not there already
			if table.find(Blocks[Data.Block].OutSignals, NextSignal) == nil then
				table.insert(Blocks[Data.Block].OutSignals, NextSignal)
			end
		end

		-- Check it has a model
		if Data.Model == nil then
			error('Signal \'' .. Name .. '\' does not have a model in the folder referenced in Config. (1)')
		end
	end



	-- Update every block a few times to get signals off red (which they start as)
	for i = 1, #Config.States do
		for Block, _ in pairs(Blocks) do
			Functions.BlockChanged(Block)
		end
	end
end



-- Initialise plugins
local Plugins = {}

for _, c in ipairs(script.Plugins:GetChildren()) do
	table.insert(Plugins, { ['Plugin'] = require(c), ['Priority'] = c:GetAttribute('Priority') })
end

-- Sort them to put lower priority (higher number) ones first
-- The higher priority ones are then put over the top
table.sort(Plugins, function(a, b) return a.Priority > b.Priority end)

for _, Plugin in ipairs(Plugins) do
	Plugin = Plugin.Plugin -- We don't care about priority anymore
	
	local PluginFunctions = {}  -- Pre-looping prevents weirdness due to modification of the dictionary inside the loop.
	for Name, _ in pairs(Plugin) do 
		table.insert(PluginFunctions, Name) 
	end
	
	for _, Name in ipairs(PluginFunctions) do
		-- Overwrite the existing function with this function, making the existing function this plugin's 'base' function.
		
		-- Obviously, if this function IS a base function, we don't want anything to do with it.
		-- (Plugin designers may make dummy base functions to make Lua stop complaining about unknown globals)
		if string.sub(Name, #Name - 4, #Name) == '_Base' then
			continue
		end

		Plugin[Name .. '_Base'] = Functions[Name] -- Note this isn't necessarily THE base function, as others may have written here
		Functions[Name] = Plugin[Name] -- When higher priority plugins write their base functions, that'll include our function
	end
end

Functions.Setup()
