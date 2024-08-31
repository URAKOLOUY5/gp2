// Created by Crowbar 0.74

$modelname "props/reflection_cube.mdl"

$bodygroup "Body"
{
	studio "reflection_cube_reference.smd"
}

$lod 40
{
	replacemodel "reflection_cube_reference.smd" "reflection_cube_reference_lod1.smd"
	nofacial
}
$lod 60
{
	replacemodel "reflection_cube_reference.smd" "reflection_cube_reference_lod2.smd"
	nofacial
}
$lod 90
{
	replacemodel "reflection_cube_reference.smd" "reflection_cube_reference_lod3.smd"
	nofacial
}

$surfaceprop "reflective"

$contents "solid"

$illumposition 0 -1.246 0

$mostlyopaque

$cdmaterials "models\props\"

$texturegroup "skinfamilies"
{
	{ "reflecto_cube_shell"        }
	{ "reflecto_cube_shell_rusted" }
}

$attachment "focus" "polymsh70" 0 0 20 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -17.97 -18.275 -18.275 20.746 18.275 18.275

$definebone "polymsh70" "" 0 0 0 0 0 89.999982 0 0 0 0 0 0

$opaque

$sequence "idle" {
	"reflection_cube_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "reflection_cube_physics.smd"
{
	$mass 40
	$inertia 1
	$damping 0.1
	$rotdamping 0
	$rootbone " "

}

$keyvalues
{
	prop_data 
	{
		"base" "Metal.small"
	}
}
