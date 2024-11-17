AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("OBTPRINT:ActionOnPrinter")

function ENT:Initialize()
    
	self:SetModel("models/props_c17/consolebox01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysWake()
    self:DropToFloor()
    
    self.health = 100

    self:SetMoneyAmount(0)
    self:SetBatteryCharge(100)
    self:SetTemperature(50)
    self:SetTier(1)

    self:SetTierName(OBTPRINT.Config.Tiers[self:GetTier()].name)

    self:SetPrinterOwner(self:GetCreator())

end

function ENT:RetrieveMoney(ply)

    if !IsValid(ply) or !ply:IsPlayer() then return end
    if self:GetPos():DistToSqr(ply:GetPos()) > 10000*OBTPRINT.Config.MinimalDistance or not self:IsPlayerLooking(ply) then return end

    local money = self:GetMoneyAmount()

    if money == 0 then return end

    ply:addMoney(money)
    self:SetMoneyAmount(0)

end

function ENT:UpgradeTier(ply)

    local newTier = self:GetTier() + 1

    if newTier > #OBTPRINT.Config.Tiers then return end
    
    if !IsValid(ply) or !ply:IsPlayer() or !ply:canAfford(OBTPRINT.Config.Tiers[newTier].price) then return end
    if self:GetPos():DistToSqr(ply:GetPos()) > 10000*OBTPRINT.Config.MinimalDistance or not self:IsPlayerLooking(ply) then return end

    ply:addMoney(-OBTPRINT.Config.Tiers[newTier].price)

    self:SetTier(newTier)
    self:SetTierName(OBTPRINT.Config.Tiers[newTier].name)

end

function ENT:RechargeBattery(ply)

    if !IsValid(ply) or !ply:IsPlayer() or !ply:canAfford(OBTPRINT.Config.BatteryRechargeCost) then return end
    if self:GetPos():DistToSqr(ply:GetPos()) > 10000*OBTPRINT.Config.MinimalDistance or not self:IsPlayerLooking(ply) then return end
    if self:GetBatteryCharge() == 100 then return end

    ply:addMoney(-OBTPRINT.Config.BatteryRechargeCost)
    self:SetBatteryCharge(100)

end

function ENT:CoolTemperature(ply)

    if !IsValid(ply) or !ply:IsPlayer() or !ply:canAfford(OBTPRINT.Config.TemperatureCoolCost) then return end
    if self:GetPos():DistToSqr(ply:GetPos()) > 10000*OBTPRINT.Config.MinimalDistance or not self:IsPlayerLooking(ply) then return end
    if self:GetTemperature() <= 50 then return end

    ply:addMoney(-OBTPRINT.Config.TemperatureCoolCost)
    self:SetTemperature(50)

end

function ENT:DestroyPrinter()

    self:Remove()

end

function ENT:IsPlayerLooking(ply)

    if !IsValid(ply) or !ply:IsPlayer() then return end

    return ply:GetEyeTrace().Entity == self

end

-- function ENT:Think()

--     local moneyAmount = self:GetMoneyAmount()
--     local batteryCharge = self:GetBatteryCharge()
--     local temperature = self:GetTemperature()

--     self:SetMoneyAmount(moneyAmount + (batteryCharge > 0 and OBTPRINT.Config.Tiers[self:GetTier()].printedMoney or 0))
--     self:SetBatteryCharge(math.max(0, batteryCharge - (batteryCharge > 0 and OBTPRINT.Config.BatteryDecrease or 0)))
    
--     self:SetTemperature(
--         batteryCharge > 0 and
--             math.min(100, temperature + OBTPRINT.Config.TemperatureIncrease) or
--             math.max(50, temperature - OBTPRINT.Config.TemperatureIncrease)
--     )
    
--     if temperature >= 100 then
--         self.health =- 20
--         if self.health <= 0 then
--             self:DestroyPrinter()
--         end

--     end
    
--     self:NextThink(CurTime() + OBTPRINT.Config.IntervalBetweenPrint)
--     return true

-- end

local actions = {
    [1] = {
        func = function(printer, ply)

            if not IsValid(printer) or printer:GetClass() ~= "theobtey_printer" then return end

            printer:RechargeBattery(ply)

        end
    },
    [2] = {
        func = function(printer, ply)

            if not IsValid(printer) or printer:GetClass() ~= "theobtey_printer" then return end

            printer:CoolTemperature(ply)

        end
    },
    [3] = {
        func = function(printer, ply)

            if not IsValid(printer) or printer:GetClass() ~= "theobtey_printer" then return end

            printer:RetrieveMoney(ply)

        end
    },
    [4] = {
        func = function(printer, ply)
            
            if not IsValid(printer) or printer:GetClass() ~= "theobtey_printer" then return end

            printer:RetrieveMoney(ply)

        end
    },
    [5] = {
        func = function(printer, ply)

            if not IsValid(printer) or printer:GetClass() ~= "theobtey_printer" then return end

            printer:UpgradeTier(ply)

        end
    }
}

net.Receive("OBTPRINT:ActionOnPrinter", function(_, ply)

    local num = net.ReadUInt(3)
    local printer = net.ReadEntity()

    actions[num].func(printer, ply)

end)