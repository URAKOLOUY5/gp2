ElevatorMotifs = {
	["sp_a1_intro1"] = { speed = 200 },
	["sp_a1_intro2"] = { speed = 200 }, -- this is what we do for continual elevator shafts
	["sp_a1_intro3"] = { speed = 200 }, -- this is what we do for continual elevator shafts
	["sp_a1_intro5"] = { speed = 200 }, -- this is what we do for continual elevator shafts
	["sp_a1_intro6"] = { speed = 200 }, -- this is what we do for continual elevator shafts
	["sp_a2_bridge_intro"] = { speed = 200 },
	["sp_a2_column_blocker"] = { speed = 200 },
	["sp_a2_trust_fling"] = { speed = 300 },
	["sp_a2_intro"] = { speed = 125 },
	["sp_a2_laser_intro"] = { speed = 200 },
	["sp_a2_laser_stairs"] = { speed = 200 },
	["sp_a2_dual_lasers"] = { speed = 200 },
	["sp_a2_catapult_intro"] = { speed = 200 },
	["sp_a2_pit_flings"] = { speed = 200 },
	["sp_a2_sphere_peek"] = { speed = 200 },
	["sp_a2_ricochet"] = { speed = 200 },
	["sp_a2_bridge_the_gap"] = { speed = 200 },
	["sp_a2_turret_intro"] = { speed = 200 },
	["sp_a2_laser_relays"] = { speed = 200 },
	["sp_a2_turret_blocker"] = { speed = 200 },
	["sp_a2_laser_vs_turret"] = { speed = 200 },
	["sp_a2_pull_the_rug"] = { speed = 200 },
	["sp_a2_ring_around_turrets"] = { speed = 200 },
	["sp_a2_laser_chaining"] = { speed = 200 },
	["sp_a2_triple_laser"] = { speed = 200 },
	["sp_a3_jump_intro"] = { speed = 120 },
	["sp_a3_bomb_flings"] = { speed = 120 },
	["sp_a3_crazy_box"] = { speed = 120 },
	["sp_a3_speed_ramp"] = { speed = 120 },
	["sp_a3_speed_flings"] = { speed = 120 },
	["sp_a4_intro"] = { speed = 200 },
	["sp_a4_tb_intro"] = { speed = 200 },
	["sp_a4_tb_trust_drop"] = { speed = 200 },
	["sp_a4_tb_wall_button"] = { speed = 200 },
	["sp_a4_tb_polarity"] = { speed = 200 },
	["sp_a4_tb_catch"] = { speed = 100 },
	["sp_a4_stop_the_box"] = { speed = 200 },
	["sp_a4_laser_catapult"] = { speed = 200 },
	["sp_a4_speed_tb_catch"] = { speed = 200 },
	["sp_a4_jump_polarity"] = { speed = 200 },
}

function StartMoving()
	local level = ElevatorMotifs[game.GetMap()]

	local speed = level and level.speed or 300
	if not elevator then
		print( "Starting elevator " .. self:GetName() .. " with speed " .. speed )
	else
		print( "Using default elevator speed 300" )
	end
	EntFireByHandle(self, "SetSpeedReal", speed, 0.0)
end

function ReadyForTransition()
	-- see if we need to teleport to somewhere else or 
	PrepareTeleport()
end

function FailSafeTransition()
	EntFire("@transition_from_map","Trigger","",0.0)
  	EntFire("@transition_with_survey","Trigger","",0.0)
end

function PrepareTeleport()
	local level = ElevatorMotifs[game.GetMap()]

	if Globals.TransitionFired == 1 then return end

	if level then
		if level.motifs then
			local motif = level.motifs[Globals.MotifIndex]
			print("Trying to connect to motif" .. motif)

			if motif == "transition" then
				EntFire("@transition_with_survey","Trigger","",0.0)
				EntFire("@transition_from_map","Trigger","",0.0)
				return
			else
				EntFireByHandle(self, "SetRemoteDestination", level.motifs[Globals.MotifIndex], 0.0)
				if Globals.MotifIndex == 0 then
					EntFire("departure_elevator-elevator_1","Stop","",0.05)
				end
			end
		else
			if Globals.TransitionReady == 1 then
				Globals.TransitionFired = 1
				EntFire("@transition_from_map","Trigger","",0.0)
				EntFire("@transition_with_survey","Trigger","",0.0)
			end

			-- just bail, we don't need to do anything weird here.
			return
		end
	else
		Globals.TransitionFired = 1
		EntFire("@transition_with_survey","Trigger","",0.0)
		EntFire("@transition_from_map","Trigger","",0.0)
		print("Level not found in elevator_motifs defaulting to transition")

		-- just bail, we don't need to do anything weird here.
		return
	end

	EntFireByHandle(self,"Enable",0.0)
	Globals.MotifIndex = Globals.MotifIndex + 1
end

function OnPostPlayerSpawn(ply)
	if ply:EntIndex() == 1 and not ply.NotMotifsFirstTime then
		Globals.MotifIndex = 0
		Globals.TransitionReady = 0
		Globals.TransitionFired = 0
		ply.NotMotifsFirstTime = true
	end
end