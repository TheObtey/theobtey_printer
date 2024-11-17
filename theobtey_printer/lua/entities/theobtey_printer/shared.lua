ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Printer"
ENT.Category = "TheObtey - Printer"
ENT.Author = "TheObtey"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()

    self:NetworkVar("Int", 1, "MoneyAmount")
    self:NetworkVar("Int", 2, "BatteryCharge")
    self:NetworkVar("Int", 3, "Temperature")
    self:NetworkVar("Int", 4, "Tier")

    self:NetworkVar("String", 1, "TierName")

    self:NetworkVar("Entity", 1, "PrinterOwner")
    
end