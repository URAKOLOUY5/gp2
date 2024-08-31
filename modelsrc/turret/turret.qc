// Created by Crowbar 0.74

$modelname "npcs/turret/turret.mdl"

$bodygroup "studio"
{
	studio "turret_model.smd"
}

$lod 15
{
	replacemodel "turret_model.smd" "turret_model_lod1.smd"
	nofacial
}
$lod 25
{
	replacemodel "turret_model.smd" "turret_model_lod2.smd"
	nofacial
}
$lod 35
{
	replacemodel "turret_model.smd" "turret_model_lod3.smd"
	nofacial
}
$lod 45
{
	replacemodel "turret_model.smd" "turret_model_lod4.smd"
	replacebone "LFT_Gun1" "LFT_Wing"
	replacebone "LFT_Gun2" "LFT_Wing"
	replacebone "RT_Gun1" "RT_Wing"
	replacebone "RT_Gun2" "RT_Wing"
	replacebone "cables_antenna_bone" "Base"
	replacebone "antenna_bone" "cables_antenna_bone"
	nofacial
}

$surfaceprop "solidmetal"

$contents "solid"

$illumposition 0 -1.425 34.126

$eyeposition 0 0 64

$cdmaterials "models\npcs\turret\"
$cdmaterials ""

$texturegroup "skinfamilies"
{
	{ "turret_frame02"        "turret_frame01"        "turret_casing"        "turret_eye"        }
	{ "turret_frame02"        "turret_frame01"        "turret_broken"        "turret_eye"        }
	{ "turret_frame02_bounce" "turret_frame01_bounce" "turret_casing_bounce" "turret_eye_bounce" }
	{ "turret_frame02_speed"  "turret_frame01_speed"  "turret_casing_speed"  "turret_eye_speed"  }
	{ "turret_frame02_bounce" "turret_frame01_bounce" "turret_broken_bounce" "turret_eye_bounce" }
	{ "turret_frame02_speed"  "turret_frame01_speed"  "turret_broken_speed"  "turret_eye_speed"  }
}

$attachment "eyes" "Aim_UD" 0 -0.1 13 rotate -90 -90 0
$attachment "light" "Base" 0 18 13 rotate -90 -90 0
$attachment "LFT_Gun1_Muzzle" "LFT_Gun1" 0 0 1 rotate -90 -90 0
$attachment "LFT_Gun2_Muzzle" "LFT_Gun2" 0 0 3 rotate -90 -90 0
$attachment "RT_Gun1_Muzzle" "RT_Gun1" 0 0 1 rotate -90 -90 0
$attachment "RT_Gun2_Muzzle" "RT_Gun2" 0 0 3 rotate -90 -90 0
$attachment "Wire1_start" "Base" -2.5 14 4 rotate -90 -90 0
$attachment "Wire2_start" "Base" -2.5 22 2 rotate -90 -90 0
$attachment "Wire3_start" "Base" 2.5 22 2 rotate -90 -90 0
$attachment "Wire4_start" "Base" 2.5 14 4 rotate -90 -90 0
$attachment "Wire1_end" "LFT_Wing" 7 -2 3 rotate -90 -90 0
$attachment "Wire2_end" "LFT_Wing" 7 2 -3 rotate -90 -90 0
$attachment "Wire3_end" "RT_Wing" -7 2 -3 rotate -90 -90 0
$attachment "Wire4_end" "RT_Wing" -7 -2 3 rotate -90 -90 0
$attachment "L_eject" "LFT_Wing" 1 0 0 rotate 10 -180 180
$attachment "R_eject" "RT_Wing" -1 0 0 rotate 10 0 0
$attachment "burstCenter" "Base" 0 17 5.5 rotate -90 -90 0

$cbox 0 0 0 0 0 0

$bbox -16 -16 0 16 16 64

$hboxset "default"
$hbox 1 "Base" -15.5 -18.940001 -22.709999 15.5 4.45 25.559999 "Base_hbox"
$hbox 2 "Aim_LR" -16 -13.62 -25.379999 16 -6.95 9.49 "Aim_LR_hbox"
$hbox 3 "Aim_UD" -16 -7.27 -24.120001 16 31.73 10.28 "Aim_UD_hbox"
$skipboneinbbox

$definebone "Base" "" 0 18.707941 0.000001 0 0 0 0 0 0 0 0 0
$definebone "Aim_LR" "Base" 0 18.046324 5.566179 0 0 0 0 0 0 0 0 0
$definebone "Aim_UD" "Aim_LR" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "LFT_Wing" "Aim_UD" -14.150279 0 0 0 0 0 0 0 0 0 0 0
$definebone "LFT_Gun1" "LFT_Wing" 5.45 1.799007 7.644565 0 0 0 0 0 0 0 0 0
$definebone "LFT_Gun2" "LFT_Wing" 5.45221 -2.218403 7.001916 0 0 0 0 0 0 0 0 0
$definebone "RT_Wing" "Aim_UD" 14.15 0 0 0 0 0 0 0 0 0 0 0
$definebone "RT_Gun1" "RT_Wing" -5.45 1.800289 7.644565 0 0 0 0 0 0 0 0 0
$definebone "RT_Gun2" "RT_Wing" -5.45 -2.218403 7.001916 0 0 0 0 0 0 0 0 0
$definebone "body" "Base" 0 18.046324 5.566179 0 0 0 0 0 0 0 0 0
$definebone "eyeball_bone" "Base" 0 18.046324 5.566179 90.000003 90.000003 0 0 0 0 0 0 0
$definebone "eyeball_light" "eyeball_bone" -5.643266 0 0 0 0 0 0 0 0 0 0 0
$definebone "cables_antenna_bone" "Base" 0 18.046324 5.566179 0 0 -90.000003 0 0 0 0 0 0
$definebone "antenna_bone" "cables_antenna_bone" 0 0 10 0 0 0 0 0 0 0 0 0
$definebone "legbase_bone" "Base" 0 18.046324 5.566179 90.000003 0 0 0 0 0 0 0 0
$definebone "Left_leg" "legbase_bone" 6.182672 -9.688761 -2.215209 -64.999994 -180.000005 90.000009 0 0 0 0 0 0
$definebone "Left_rotator" "Left_leg" 0.128016 -7.776709 -2.173876 0 0 0 0 0 0 0 0 0
$definebone "Left_foot" "Left_rotator" 1.155865 -11.753292 -8.000408 0 0 0 0 0 0 0 0 0
$definebone "Left_sub_rotator" "Left_leg" 0 -7.741129 -2.068363 0 0 0 0 0 0 0 0 0
$definebone "Right_leg" "legbase_bone" 6.182672 -9.688761 2.215209 -65.000001 0 -90.000009 0 0 0 0 0 0
$definebone "Right_rotator" "Right_leg" -0.128016 -7.77671 -2.173876 0 0 180.000005 0 0 0 0 0 0
$definebone "Right_foot" "Right_rotator" -1.155865 11.753294 8.000408 0 0 0 0 0 0 0 0 0
$definebone "Right_sub_rotator" "Right_leg" 0 -7.74113 -2.068361 0 0 180.000005 0 0 0 0 0 0
$definebone "back_leg" "legbase_bone" 9.105322 -5.491165 0 -90.000003 -90.000003 0 0 0 0 0 0 0
$definebone "back_leg_foot1" "back_leg" 0 12.378824 -3.853943 0 0 0 0 0 0 0 0 0


$sectionframes 30 2500

$poseparameter "aim_yaw" -60 60 loop 0
$poseparameter "aim_pitch" -15 15 loop 0

$animation "aim_right_corrective_animation" "turret_anims\aim_right_corrective_animation.smd" {
}

$animation "aim_left_corrective_animation" "turret_anims\aim_left_corrective_animation.smd" {
}

$animation "aim_up_corrective_animation" "turret_anims\aim_up_corrective_animation.smd" {
}

$animation "aim_down_corrective_animation" "turret_anims\aim_down_corrective_animation.smd" {
}

$animation "aim_neutral" "turret_anims\aim_neutral.smd" {
	fps 30
}

$animation "aim_up" "turret_anims\aim_up.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "aim_up_corrective_animation" 0
}

$animation "aim_down" "turret_anims\aim_down.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "aim_down_corrective_animation" 0
}

$animation "aim_right" "turret_anims\aim_right.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "aim_right_corrective_animation" 0
}

$animation "aim_left" "turret_anims\aim_left.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "aim_left_corrective_animation" 0
}

$sequence "idle" {
	"turret_anims\idle.smd"
	activity "ACT_FLOOR_TURRET_CLOSED_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "deploy" {
	"turret_anims\deploy.smd"
	activity "ACT_FLOOR_TURRET_OPEN" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "idlealert" {
	"turret_anims\idlealert.smd"
	activity "ACT_FLOOR_TURRET_OPEN_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 10
	loop
}

$sequence "fire" {
	"turret_anims\fire.smd"
	activity "ACT_FLOOR_TURRET_FIRE" 1
	{ event AE_NPC_MUZZLEFLASH 0 "COMBINE LFT_Gun1_muzzle" }
	{ event AE_NPC_MUZZLEFLASH 0 "COMBINE RT_Gun1_muzzle" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "fire2" {
	"turret_anims\fire2.smd"
	activity "ACT_FLOOR_TURRET_FIRE2" 1
	{ event AE_NPC_MUZZLEFLASH 0 "COMBINE LFT_Gun2_muzzle" }
	{ event AE_NPC_MUZZLEFLASH 0 "COMBINE RT_Gun2_muzzle" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "retract" {
	"turret_anims\retract.smd"
	activity "ACT_FLOOR_TURRET_CLOSE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "eye_off" {
	"turret_anims\eye_off.smd"
	activity "ACT_FLOOR_TURRET_DIE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "idle_eye_off" {
	"turret_anims\idle_eye_off.smd"
	activity "ACT_FLOOR_TURRET_DIE_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "aim_updown" {
	"turret_anims\aim_updown.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "aim_leftright" {
	"turret_anims\aim_leftright.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "auto_leftright" {
	"aim_right"
	"aim_left"
	autoplay
	blend "aim_yaw" -60 60
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
}

$sequence "auto_updown" {
	"aim_up"
	"aim_down"
	autoplay
	blend "aim_pitch" -15 15
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
}

$sequence "carry_pose" {
	"turret_anims\carry_pose.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "3penny_lo" {
	"turret_anims\3penny_lo.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "3penny_mid" {
	"turret_anims\3penny_mid.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "3penny_hi" {
	"turret_anims\3penny_hi.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "3penny_perc" {
	"turret_anims\3penny_perc.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "recital_lo" {
	"turret_anims\recital_lo.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "recital_mid" {
	"turret_anims\recital_mid.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "recital_hi" {
	"turret_anims\recital_hi.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "recital_perc" {
	"turret_anims\recital_perc.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$collisionmodel "turret_physics.smd"
{
	$mass 100
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 8

}

$collisiontext
{
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib2"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib3"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib12"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib13"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib15"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib16"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib20"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib21"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib24"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
	break 
	{
		"model" "npcs/turret/turret_fx_break_gib25"
		"fadetime" "20.0"
		"debris" "1"
		"burst" "500"
	}
}

$keyvalues
{
	prop_data 
	{
		"base" "Metal.Medium"
		"health" "40"
	}
}
