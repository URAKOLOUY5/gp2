-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Bomb
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

local exploding_futbol_use_cooldown_time = CreateConVar("exploding_futbol_use_cooldown_time", "0.7", FCVAR_CHEAT, "The cooldown time for the use key after the player picks up the futbol.");
local exploding_futbol_explosion_radius = CreateConVar("exploding_futbol_explosion_radius", "200", FCVAR_CHEAT, "The radius of the explosion for the exploding futbol.");
local exploding_futbol_explosion_magnitude = CreateConVar("exploding_futbol_explosion_magnitude", "0", FCVAR_CHEAT, "The magnitude of the explosion for the exploding futbol.");
local exploding_futbol_explosion_damage = CreateConVar("exploding_futbol_explosion_damage", "25.0", FCVAR_CHEAT, "The damage of the explosion for the exploding futbol.");
local exploding_futbol_explosion_damage_falloff = CreateConVar("exploding_futbol_explosion_damage_falloff", "0.75", FCVAR_CHEAT, "The percentage of damage taken at the edge of the explosion.");
local exploding_futbol_start_color = CreateConVar("exploding_futbol_start_color", "255 255 255 255", FCVAR_CHEAT, "The starting color of the exploding futbol.");
local exploding_futbol_end_color = CreateConVar("exploding_futbol_end_color", "255 106 0 255", FCVAR_CHEAT, "The ending color of the exploding futbol, before it starts the final explode sequence.");
local exploding_futbol_flash_start_color = CreateConVar("exploding_futbol_flash_start_color", "255 255 0 255", FCVAR_CHEAT, "The start color for the futbol flashing before it explodes.");
local exploding_futbol_flash_end_color = CreateConVar("exploding_futbol_flash_end_color", "255 0 0 255", FCVAR_CHEAT, "The final color of the exploding futbol, right before it explodes.");
local exploding_futbol_flash_start_time = CreateConVar("exploding_futbol_flash_start_time", "3.0", FCVAR_CHEAT, "The time before the futbol explodes when it start to flash.");
local exploding_futbol_flash_duration = CreateConVar("exploding_futbol_flash_duration", "1.0", FCVAR_CHEAT, "The flash duration of the exploding futbol, right before it explodes.");
local exploding_futbol_hit_breakables = CreateConVar("exploding_futbol_hit_breakables", "1", FCVAR_CHEAT, "If the exploding futbol should hit breakable entities.");
local exploding_futbol_explode_on_fizzle = CreateConVar("exploding_futbol_explode_on_fizzle", "0", FCVAR_CHEAT, "If the exploding futbol should explode when it fizzles.");
local exploding_futbol_physics_punt_player = CreateConVar("exploding_futbol_physics_punt_player", "1", FCVAR_CHEAT, "Physically perturb the player when the explosion hits them");
local exploding_futbol_phys_mag = CreateConVar("exploding_futbol_phys_mag", "100", FCVAR_CHEAT, "Magnitude of physics force for an exploding futbol");
local exploding_futbol_phys_rad = CreateConVar("exploding_futbol_phys_rad", "45", FCVAR_CHEAT, "Magnitude of physics force for an exploding futbol");
local sv_futbol_funnel_max_correct = CreateConVar("sv_futbol_funnel_max_correct", "128", FCVAR_DEVELOPMENTONLY, "Max distance to move our hit-target if there\'s a portal nearby it");

PrecacheParticleSystem("bomb_trail")

EXPLODING_FUTBOL_HELD_BY_NONE = 0
EXPLODING_FUTBOL_HELD_BY_PLAYER = 1
EXPLODING_FUTBOL_HELD_BY_SPAWNER = 2
EXPLODING_FUTBOL_HELD_BY_CATCHER = 3
EXPLODING_FUTBOL_HELD_BY_COUNT = 4

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 'TimerActive')
    self:NetworkVar("Bool", 'ExplosionOnTouch')
    
    self:NetworkVar("Int", 'Holder')
    
    self:NetworkVar("Float", 'ExplosionTimer')
    self:NetworkVar("Float", 'TotalTimer')
    self:NetworkVar("Float", 'LastFlashTime')
    self:NetworkVar("Float", 'LastTickTime')
end

function ENT:Initialize()
    self:SetModel("models/npcs/personality_sphere_angry.mdl")
    self:ResetSequence("rot")
    self:PhysicsInit(SOLID_VPHYSICS)

    ParticleEffectAttach("bomb_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)

    self.NextThinkTime = 0

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:KeyValue(k, v)
    if k == "ExplodeOnTouch" then
        self:SetExplosionOnTouch(tobool(v))
    end
end

function ENT:Think()
    if self.NextThinkFunction 
    and isfunction(self.NextThinkFunction)
    and CurTime() > self.NextThinkTime then
        self:NextThinkFunction()
    end

    self:NextThink(CurTime() + 0.1)
    return true
end

function ENT:SetNextThink(nextThink)
    self.NextThinkTime = nextThink
end

function ENT:SetThink(nextThinkFunc)
    if nextThinkFunc then
        self.NextThinkFunction = nextThinkFunc
    end
end

function ENT:TimerThink()
    if self:GetTimerActive() then
        if self:GetExplosionTimer() <= exploding_futbol_flash_start_time:GetFloat() then
            self:EmitSound("NPC_FloorTurret.DeployingKlaxon")
            if (CurTime() - self:GetLastFlashTime()) > exploding_futbol_flash_duration:GetFloat() then
                self:SetLastFlashTime(CurTime())
            end
        end

        if CurTime() - self:GetLastTimerSoundTime() > exploding_futbol_flash_duration:GetFloat() then
            self:EmitSound("Portal.room1_TickTock")
            self:SetLastTimerSoundTime(CurTime())
        end

        if self:GetExplosionTimer() <= 0 then
            self:EmitSound("EnergyBall.Explosion")
            self:KillFutbol()
            self:StopFutbolTimer()
        end

        self:SetNextThink(CurTime() + engine.TickInterval())
    end
end

function ENT:KillThink()
    self:ExplodeFutbol()
end

function ENT:ActivateFutbolTimer(timer)
    self:SetTotalTimer(timer)
    self:SetExplosionTimer(timer)

    if timer > 0 then
        self:SetTimerActive(true)
        self:SetLastTickTime(CurTime())
        self:SetLastTimerSoundTime(CurTime() - 1.0)
        self:SetLastFlashTime(CurTime())

        self:SetColor(exploding_futbol_start_color:GetBool(), exploding_futbol_start_color:GetBool(), exploding_futbol_start_color:GetBool())
        self:SetThink(self.TimerThink)
    end
end

function ENT:StopFutbolTimer()
    self:SetTimerActive(false)
    self:SetRenderColor(exploding_futbol_start_color:GetBool(), exploding_futbol_start_color:GetBool(), exploding_futbol_start_color:GetBool())
end

function ENT:OnTakeDamage(dmg)
    if not self:GetExplosionOnTouch() then
        return 0
    end

    if self:GetHolder() == EXPLODING_FUTBOL_HELD_BY_SPAWNER or self:GetHolder() == EXPLODING_FUTBOL_HELD_BY_CATCHER then
        return 0
    end
end

function ENT:OnFizzled()
    if exploding_futbol_explode_on_fizzle:GetBool() then
        self:ExplodeFutbol()
    end
end

function ENT:PhysicsCollide()
    if self:GetExplosionOnTouch() and self:GetHolder() == EXPLODING_FUTBOL_HELD_BY_NONE then
        self:SetThink(self.KillThink)
    end

    print('collide')
end

function ENT:KillFutbol()
    local info = DamageInfo()
    info:SetAttacker(self)
    info:SetInflictor(self)
    info:SetDamage(self:Health())
    info:SetDamageType(DMG_BLAST)
    info:SetDamagePosition(self:GetPos())
    info:SetDamageForce(Vector(500,500,500))
end

function ENT:ExplodeFutbol()
    local origin = self:GetPos()
    local angles = self:GetAngles()

    -- Explosion damage
    local explosionMagnitude = exploding_futbol_explosion_magnitude:GetInt()
    local explosionRadius = exploding_futbol_explosion_radius:GetFloat()
    local explosionDamage = exploding_futbol_explosion_damage:GetFloat()

    util.BlastDamage(self, self, origin, explosionRadius, explosionDamage)

    -- Create explosion effect
    local effectData = EffectData()
    effectData:SetOrigin(origin)
    effectData:SetMagnitude(explosionMagnitude)
    effectData:SetRadius(explosionRadius)
    util.Effect("Explosion", effectData)

    self:Remove()
end