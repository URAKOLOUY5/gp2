// Created by Crowbar 0.74

$modelname "container_ride/MasterTransform.mdl"

$bodygroup "main"
{
	studio "MasterTransform.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -60.029 114.455 290.671

$cdmaterials "models\container_ride"
$cdmaterials "models\effects\"
$cdmaterials ""

$attachment "vstAttachment" "vstAttachment" 0 0 0 rotate 0 0 0
$attachment "vstAttachment_noorient" "vstAttachment_noorient" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -455.637 -120.058 0 226.726 0 581.342

$definebone "RootTransform" "" 119.557861 -580.842468 -226.7258 0 0 0 0 0 0 0 0 0
$definebone "vstAttachment" "RootTransform" 0 0 0 -90.000003 -90.000003 0 0 0 0 0 0 0
$definebone "pCube7" "" 0 0 -681.86261 0 0 0 0 0 0 0 0 0
$definebone "vstAttachment_noorient" "" 119.557861 -580.842468 -226.725784 -90.000003 -90.000003 0 0 0 0 0 0 0


// The 32 below is a guess until further is known about the format.
$animblocksize 32

$bonesaveframe "RootTransform" position
$bonesaveframe "vstAttachment" position
$bonesaveframe "pCube7" position
$bonesaveframe "vstAttachment_noorient" position

$sectionframes 30 399

$sequence "idle" {
	"mastertransform_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim1" {
	"mastertransform_anims\anim1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt1" {
	"mastertransform_anims\halt1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim2" {
	"mastertransform_anims\anim2.smd"
	{ event AE_CL_PLAYSOUND 92 "xray.beep" }
	{ event AE_CL_PLAYSOUND 719 "xray.beep" }
	{ event AE_CL_PLAYSOUND 835 "xray.beep" }
	{ event AE_CL_PLAYSOUND 1368 "xray.beep" }
	{ event AE_CL_PLAYSOUND 1648 "xray.beep" }
	{ event AE_CL_PLAYSOUND 2854 "xray.beep" }
	{ event AE_CL_PLAYSOUND 3269 "xray.beep" }
	{ event AE_CL_PLAYSOUND 3645 "xray.beep" }
	{ event 1100 92 "fireuser1" }
	{ event 1100 272 "fireuser2" }
	{ event 1100 469 "fireuser1" }
	{ event 1100 558 "fireuser1" }
	{ event 1100 578 "fireuser1" }
	{ event 1100 602 "fireuser2" }
	{ event 1100 719 "fireuser1" }
	{ event 1100 835 "fireuser1" }
	{ event 1100 1368 "fireuser2" }
	{ event 1100 1648 "fireuser1" }
	{ event 1100 2824 "fireuser3" }
	{ event 1100 2854 "fireuser4" }
	{ event 1100 3269 "fireuser4" }
	{ event 1100 3645 "fireuser4" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt2" {
	"mastertransform_anims\halt2.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "anim3" {
	"mastertransform_anims\anim3.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "halt3" {
	"mastertransform_anims\halt3.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}
