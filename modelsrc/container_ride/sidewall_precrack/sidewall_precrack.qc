// Created by Crowbar 0.74

$modelname "container_ride/sideWall_preCrack.mdl"

$bodygroup "main"
{
	studio "sideWall_preCrack.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -11.979 12.662 297.17

$cdmaterials "models\container_ride"
$cdmaterials "models\effects\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -252.051 -119.758 13.499 226.726 95.8 580.842

$definebone "sideWall_preCrack" "" -0.2 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"sidewall_precrack_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}
