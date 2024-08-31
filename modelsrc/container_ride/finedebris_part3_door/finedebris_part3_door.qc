// Created by Crowbar 0.74

$modelname "container_ride/fineDebris_part3_door.mdl"

$bodygroup "main"
{
	studio "fineDebris_part3_door.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 66 252.801 70.499

$cdmaterials "models\container_ride"
$cdmaterials "models\effects\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -253.551 44 13.498 -252.051 88 127.499

$definebone "NewBackDoorEXP" "" 185.557861 -510.343445 -479.526855 -90.000003 -90.000003 0 0 0 0 0 0 0


// The 32 below is a guess until further is known about the format.
$animblocksize 32

$bonesaveframe "NewBackDoorEXP" position

$sectionframes 30 399

$sequence "idle" {
	"finedebris_part3_door_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim1" {
	"finedebris_part3_door_anims\anim1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt1" {
	"finedebris_part3_door_anims\halt1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim2" {
	"finedebris_part3_door_anims\anim2.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt2" {
	"finedebris_part3_door_anims\halt2.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim3" {
	"finedebris_part3_door_anims\anim3.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt3" {
	"finedebris_part3_door_anims\halt3.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}
