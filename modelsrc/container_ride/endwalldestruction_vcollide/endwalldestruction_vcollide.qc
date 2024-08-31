// Created by Crowbar 0.74

$modelname "container_ride/endWallDestruction_vcollide.mdl"

$bodygroup "main"
{
	studio "endWallDestruction_vcollide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -1022.392 1876.302 -1060.527

$cdmaterials "models\container_ride"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -3968.636 -2399.303 -2158.605 216.293 354.771 37.801

$definebone "endRubblevcollide" "" 0 0 0 0 0 0 0 0 0 0 0 0


// The 32 below is a guess until further is known about the format.
$animblocksize 32

$bonesaveframe "endRubblevcollide" position

$sequence "idle" {
	"endwalldestruction_vcollide_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$collisionmodel "endwalldestruction_vcollide_physics.smd"
{
	$mass 100
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 7

}
