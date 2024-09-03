debug = false

function printdebug(msg)
    if debug then
        print(msg)
    end
end

-- set up global counter
if not Globals.GlobalMusicalCatcherCount then
	Globals.GlobalMusicalCatcherCount = 0
	printdebug("===== INITIALIZING GlobalMusicalCatcherCount")
end

-- increment the count
Globals.GlobalMusicalCatcherCount = Globals.GlobalMusicalCatcherCount + 1
printdebug("===== GlobalMusicalCatcherCount is now " .. Globals.GlobalMusicalCatcherCount )

-- set up global containing currently active catchers
if not Globals.GlobalMusicalCatcherPowered then
	Globals.GlobalMusicalCatcherPowered = 0
end

-- connect to catcher entity IO
self:ConnectOutput( "OnPowered", "CatcherPowerOn", self )
self:ConnectOutput( "OnUnpowered", "CatcherPowerOff", self )

-- --------------------------------------------
-- called when catcher becomes powered
-- --------------------------------------------
function CatcherPowerOn()
	Globals.GlobalMusicalCatcherPowered = Globals.GlobalMusicalCatcherPowered + 1
	printdebug("===== Catcher " .. self:GetName() .. " powered ON!  Playing sound " .. self:GetName() .. "_music_" .. Globals.GlobalMusicalCatcherPowered )
	EntFire( self:GetName() .. "_music_" .. Globals.GlobalMusicalCatcherPowered, "playsound", 0, 0 )
	QueueAdd()
end

-- --------------------------------------------
-- called when catcher becomes unpowered
-- --------------------------------------------
function CatcherPowerOff()
	Globals.GlobalMusicalCatcherPowered = Globals.GlobalMusicalCatcherPowered - 1
	printdebug("===== Catcher " .. self:GetName() .. " powered OFF!")
	EntFire( self:GetName() .. "_music_*", "stopsound", 0, 0 )
	RemoveSelfFromQueue()

	-- update music playlist
	RefreshMusicPlaylist()
end

function RefreshMusicPlaylist()
	for index, val in pairs(Globals.GlobalCatcherPlayList) do
		if Globals.GlobalCatcherPlayList[index].song ~= Globals.GlobalCatcherPlayList[index].catcher .. "_music_" .. index then
			printdebug(" =====  SONG " .. Globals.GlobalCatcherPlayList[index].song .. " DOES NOT MATCH " .. Globals.GlobalCatcherPlayList[index].catcher .. "_music_" .. (index) .. " RESETTING ====" )
			EntFire( Globals.GlobalCatcherPlayList[index].catcher .. "_music_*", "stopsound", 0, 0 )
			
			-- playing correct sound
			printdebug("==== playing correct sound: " .. Globals.GlobalCatcherPlayList[index].catcher .. "_music_" .. index )
			EntFire( Globals.GlobalCatcherPlayList[index].catcher .. "_music_" .. (index), "playsound", 0, 0 )

			-- update table with new song name
			Globals.GlobalCatcherPlayList[index].song = Globals.GlobalCatcherPlayList[index].catcher .. "_music_" .. index
		end
	end
end

-- --------------------------------------------
-- queue Functions
-- --------------------------------------------

if not Globals.GlobalCatcherPlayList then
	-- set up global queue
	Globals.GlobalCatcherPlayList = {}
end

function OnPostSpawn()
	if not Globals.GlobalCatcherPlayList then
		QueueInitialize()
		printdebug("===== Initializing QUEUE.  Length: " .. #Globals.GlobalCatcherPlayLis )
	end
end

-- Initialize the queue
function QueueInitialize()
	Globals.GlobalCatcherPlayList = {}
end

-- Add to the queue
function QueueAdd()
	entry = {}

	entry = {
		catcher = self:GetName(), 
		song = self:GetName() .. "_music_" .. Globals.GlobalMusicalCatcherPowered
	}

	table.insert(Globals.GlobalCatcherPlayList, entry)
	printdebug("====== Adding " .. self:GetName() .. " to queue. Queue Length = " .. #Globals.GlobalCatcherPlayList )
end

-- Display the queue
function DisplayQueue()
	if debug then
		for index, val in pairs(Globals.GlobalCatcherPlayList) do
			print("===== " .. index .. " - " .. Globals.GlobalCatcherPlayLis[index].catcher .. "   | Music - " .. Globals.GlobalCatcherPlayLis[index].song )
		end
	end
end

-- Sort through queue and remove self if found
function RemoveSelfFromQueue()
	catchername = self:GetName()
	printdebug("===== ATTEMPTING to remove self from queue: " .. catchername )

	if (#Globals.GlobalCatcherPlayList == 0) then
		return false
	end

	for index, val in pairs(Globals.GlobalCatcherPlayList) do
		if catchername == Globals.GlobalCatcherPlayList[index].catcher then
			printdebug("====== removing #" .. index .. " named: " .. Globals.GlobalCatcherPlayList[index].catcher )
			table.remove(Globals.GlobalCatcherPlayList, index)
			return true
		end
	end

	return true
end