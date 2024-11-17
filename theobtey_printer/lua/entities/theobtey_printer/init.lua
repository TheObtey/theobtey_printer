AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("OBTPRINT:RechargeBattery")
util.AddNetworkString("OBTPRINT:CoolTemperature")
util.AddNetworkString("OBTPRINT:RetrieveMoney")

function ENT:Initialize()
    
	self:SetModel("models/props_c17/consolebox01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysWake()
    self:DropToFloor()
    
    self.timer = CurTime()
    self.health = 3

    self:SetMoneyAmount(0)
    self:SetBatteryCharge(100)
    self:SetTemperature(50)

    self:SetPrinterOwner(self:GetCreator():Nick())
    self:SetTier("BASIQUE") -- not used yet

end

function ENT:Think()
    if CurTime() < self.timer + OBTPRINT.Config.IntervalBetweenPrint then return end

    self:SetMoneyAmount(self:GetBatteryCharge() > 0 and self:GetMoneyAmount() + OBTPRINT.Config.MoneyPrinted or self:GetMoneyAmount())
    self:SetBatteryCharge(self:GetBatteryCharge() > 0 and self:GetBatteryCharge() - OBTPRINT.Config.BatteryDecrease or 0)
    
    -- yeah you can blame me on this one
    self:SetTemperature(
        self:GetBatteryCharge() > 0 and
            (self:GetTemperature() < 100 and self:GetTemperature() + OBTPRINT.Config.TemperatureIncrease or 100) or
            (self:GetTemperature() > 50 and self:GetTemperature() - OBTPRINT.Config.TemperatureIncrease or 50)
    )

    if self:GetTemperature() >= 100 then
        if self.health <= 0 then
            -- explode the printer
            self:Remove() -- It's 2:54am let me sleep for god sake!
        end
        self.health = self.health - 1
    end
    
    self.timer = CurTime()
end


net.Receive("OBTPRINT:RechargeBattery", function(_, ply)
    
    local printer = net.ReadEntity()
    
    if not ply:canAfford(OBTPRINT.Config.BatteryRechargeCost) or !isentity(printer) then return end
    if printer:GetClass() ~= "theobtey_printer" then return end
    if printer:GetBatteryCharge() == 100 then return end
    
    ply:addMoney(-OBTPRINT.Config.BatteryRechargeCost)
    printer:SetBatteryCharge(100)

end)

net.Receive("OBTPRINT:CoolTemperature", function(_, ply)

    local printer = net.ReadEntity()
    
    if not ply:canAfford(OBTPRINT.Config.TemperatureCoolCost) or !isentity(printer) then return end
    if printer:GetClass() ~= "theobtey_printer" then return end
    if printer:GetTemperature() == 50 then return end

    ply:addMoney(-OBTPRINT.Config.TemperatureCoolCost)
    printer:SetTemperature(50)

end)

net.Receive("OBTPRINT:RetrieveMoney", function(_, ply)

    local printer = net.ReadEntity()
    
    if !isentity(printer) then return end
    if printer:GetClass() ~= "theobtey_printer" then return end

    local money = printer:GetMoneyAmount()

    if money == 0 then return end

    ply:addMoney(money)
    printer:SetMoneyAmount(0)

end)