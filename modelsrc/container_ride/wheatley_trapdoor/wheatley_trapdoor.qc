// Created by Crowbar 0.74

$modelname "container_ride/wheatley_trapDoor.mdl"

$bodygroup "main"
{
	studio "wheatley_trapDoor.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -62.777 -125.305 361.17

$cdmaterials "models\container_ride"
$cdmaterials "models\effects\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox 23.883 -119.558 141.498 226.726 -5.996 580.842

$definebone "polySurface2498" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "trapDoor2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "trapDoor1" "" 0 0 0 0 0 0 0 0 0 0 0 0


// The 32 below is a guess until further is known about the format.
$animblocksize 32

$bonesaveframe "polySurface2498" position
$bonesaveframe "trapDoor2" position
$bonesaveframe "trapDoor1" position

$sectionframes 30 119

$sequence "idle" {
	"wheatley_trapdoor_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim1" {
	"wheatley_trapdoor_anims\anim1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt1" {
	"wheatley_trapdoor_anims\halt1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim2" {
	"wheatley_trapdoor_anims\anim2.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt2" {
	"wheatley_trapdoor_anims\halt2.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim3" {
	"wheatley_trapdoor_anims\anim3.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt3" {
	"wheatley_trapdoor_anims\halt3.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim4" {
	"wheatley_trapdoor_anims\anim4.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt4" {
	"wheatley_trapdoor_anims\halt4.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}
