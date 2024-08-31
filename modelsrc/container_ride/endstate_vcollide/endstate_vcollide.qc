// Created by Crowbar 0.74

$modelname "container_ride/endstate_vcollide.mdl"

$bodygroup "main"
{
	studio "endstate_vcollide_basemodel.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 2278.917 -4204.141 3303.728

$cdmaterials "models\container_ride"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox 3841.34 2211.622 2846.506 4395.718 2569.938 3451.233

$definebone "pCube8" "" 2465.768555 2826.471924 4168.456543 0.235351 -0.75758 6.822316 0 0 0 0 0 0


$sequence "idle" {
	"endstate_vcollide_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$collisionmodel "endstate_vcollide_physics.smd"
{
	$mass 100
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 9

}
