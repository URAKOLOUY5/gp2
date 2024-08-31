function PrecacheContainerAnimations()
end

function StartContainerAnimations()
    EntFire("@container_stacks_1", "setanimation", "anim1", 0 )
	EntFire("@container_stacks_2", "setanimation", "anim1", 0 )
	EntFire("@container_stacks_2", "DisableDraw", "", 0 )
end

function ShowHiddenContainers()
    EntFire("@container_stacks_2","EnableDraw", "", 0 )
end

function SetupContainerAttachments()
end