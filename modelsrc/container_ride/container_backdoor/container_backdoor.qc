// Created by Crowbar 0.74

$modelname "container_ride/container_backDoor.mdl"

$bodygroup "main"
{
	studio "backDoor.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 66 252.801 70.499

$cdmaterials "models\container_ride"
$cdmaterials "models\effects\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -253.551 44 13.498 -252.051 88 127.499

$definebone "newbackdoor_NewBackDoor" "" 185.557861 -510.343445 -479.526855 -90.000003 -90.000003 0 0 0 0 0 0 0


// The 32 below is a guess until further is known about the format.
$animblocksize 32

$bonesaveframe "newbackdoor_NewBackDoor" position

$sequence "idle" {
	"container_backdoor_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim1" {
	"container_backdoor_anims\anim1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt1" {
	"container_backdoor_anims\halt1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim2" {
	"container_backdoor_anims\anim2.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt2" {
	"container_backdoor_anims\halt2.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}
