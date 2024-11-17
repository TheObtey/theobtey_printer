include("shared.lua")

local colors = {
    ["bg"] = Color(42,42,42),
    ["border"] = Color(104,104,104),
    ["slot"] = Color(48,48,48),
    ["slot_hover"] = Color(38,38,38)
}

local currentColors = {
    ["upgrade_btn"] = colors["slot"],
    ["battery_btn"] = colors["slot"],
    ["temperature_btn"] = colors["slot"],
    ["money_btn"] = colors["slot"]
}

local upgradeCooldown = 0
local batteryCooldown = 0
local temperatureCooldown = 0
local retrieveMoneyCooldown = 0

OBTPRINT.Fonts = OBTPRINT.Fonts or {}

-- Automatic font-creation function
function OBTPRINT:Font(iSize, sType)

    iSize = iSize or 15
    sType = sType or "Medium" -- Availables: Thin, Light, Medium, SemiBold, Bold, ExtraBold, Italic

    local sName = ("OBTPRINT:Font:%i:%s"):format(iSize, sType)
    if not OBTPRINT.Fonts[sName] then

        surface.CreateFont(sName, {
            font = ("K2D %s"):format(sType):Trim(),
            size = iSize,
            weight = 500,
            extended = false,
            antialias = true
        })

        OBTPRINT.Fonts[sName] = true

    end

    return sName

end

function ENT:Draw()
    
    self:DrawModel()

    if OBTPRINT.imgui.Start3D2D(self:LocalToWorld(Vector(-15.9,-14.8,10.97)), self:LocalToWorldAngles(Angle(0,90,-.13)), .05, 1000, 750) then

        -- Draw background
        draw.RoundedBox(0, 0, 0, 600, 600, colors["border"])
        draw.RoundedBox(0, 5, 5, 590, 590, colors["bg"])
        
        -- Draw player's name
        draw.RoundedBox(0, 15, 15, 570, 60, colors["border"])
        draw.RoundedBox(0, 20, 20, 560, 50, colors["slot"])
        
        draw.SimpleText(self:GetPrinterOwner():Nick(), OBTPRINT:Font(32), 300, 42, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        -- Draw printer tier
        draw.RoundedBox(0, 15, 85, 570, 60, colors["border"])
        draw.RoundedBox(0, 20, 90, 560, 50, colors["slot"])
        
        draw.SimpleText(self:GetTierName(), OBTPRINT:Font(32), 300, 114, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)    
        
        -- Draw upgrade slot
        draw.RoundedBox(0, 180, 155, 240, 60, colors["border"])
        draw.RoundedBox(0, 185, 160, 230, 50, currentColors["upgrade_btn"])

        draw.SimpleText(OBTPRINT.Constants.texts[OBTPRINT.Config.Language]["upgrade"], OBTPRINT:Font(38), 300, 185, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if OBTPRINT.imgui.IsHovering(180, 155, 240, 60) then
            
            currentColors["upgrade_btn"] = colors["slot_hover"]
        
            if OBTPRINT.imgui.IsPressed(180, 155, 240, 60) then
                
                if CurTime() >= upgradeCooldown then 
                
                    net.Start("OBTPRINT:ActionOnPrinter")
                    net.WriteUInt(1, 3)
                    net.WriteEntity(self)
                    net.SendToServer()
    
                    upgradeCooldown = CurTime() + 2
                
                end


            end

        else
            currentColors["upgrade_btn"] = colors["slot"]
        end

        -- Draw battery slot
        draw.RoundedBox(0, 15, 155, 160, 330, colors["border"])
        draw.RoundedBox(0, 20, 160, 150, 320, colors["slot"])
        draw.RoundedBox(0, 25, 434, 140, 40, colors["border"])
        draw.RoundedBox(0, 28, 437, 134, 34, currentColors["battery_btn"])
        
        draw.SimpleText(OBTPRINT.Constants.texts[OBTPRINT.Config.Language]["battery"], OBTPRINT:Font(32, "Bold"), 93, 185, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(self:GetBatteryCharge()).. "%", OBTPRINT:Font(24, "Thin"), 95, 225, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(OBTPRINT.Constants.texts[OBTPRINT.Config.Language]["battery_charge"], OBTPRINT:Font(24, "SemiBold"), 93, 455, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        local batteryCharge = self:GetBatteryCharge()
        local chargeLevels = {100, 80, 50, 20, 10}
        local materialKey = "0"

        for _, level in ipairs(chargeLevels) do
            if batteryCharge >= level then
                materialKey = tostring(level)
                break
            end
        end

        surface.SetMaterial(OBTPRINT.Constants.materials.battery[materialKey])
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(50, 240, 90, 180)
        
        if OBTPRINT.imgui.IsHovering(25,434,140,40) then
            
            currentColors["battery_btn"] = colors["slot_hover"]
            
            if OBTPRINT.imgui.IsPressed() then
                
                if CurTime() >= batteryCooldown then 
                
                    net.Start("OBTPRINT:ActionOnPrinter")
                    net.WriteUInt(2, 3)
                    net.WriteEntity(self)
                    net.SendToServer()
    
                    batteryCooldown = CurTime() + 2
                
                end

                
            end
            
        else
            currentColors["battery_btn"] = colors["slot"]
        end
        
        -- Draw temperature slot
        draw.RoundedBox(0, 425, 155, 160, 330, colors["border"])
        draw.RoundedBox(0, 430, 160, 150, 320, colors["slot"])
        draw.RoundedBox(0, 435, 434, 140, 40, colors["border"])
        draw.RoundedBox(0, 438, 437, 134, 34, currentColors["temperature_btn"])
        
        draw.SimpleText(OBTPRINT.Constants.texts[OBTPRINT.Config.Language]["temperature"], OBTPRINT:Font(32, "Bold"), 505, 185, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(self:GetTemperature()) .. "°", OBTPRINT:Font(24, "Thin"), 505, 225, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(OBTPRINT.Constants.texts[OBTPRINT.Config.Language]["temperature_cool"], OBTPRINT:Font(24), 505, 455, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        local temperature = self:GetTemperature()
        local tempLevels = {100, 80}
        local materialKey = "50"
        
        for _, level in ipairs(tempLevels) do
            if temperature >= level then
                materialKey = tostring(level)
                break
            end
        end
        
        surface.SetMaterial(OBTPRINT.Constants.materials.temperature[materialKey])
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(440, 240, 130, 180)
        
        if OBTPRINT.imgui.IsHovering(435,434,140,40) then
            
            currentColors["temperature_btn"] = colors["slot_hover"]
            
            if OBTPRINT.imgui.IsPressed() then
                
                if CurTime() >= temperatureCooldown then
                    
                    net.Start("OBTPRINT:ActionOnPrinter")
                    net.WriteUInt(3, 3)
                    net.WriteEntity(self)
                    net.SendToServer()
    
                    temperatureCooldown = CurTime() + 2
                
                end

                
            end
            
        else
            currentColors["temperature_btn"] = colors["slot"]
        end
        
        -- Draw money count
        draw.RoundedBox(0, 15, 495, 570, 90, colors["border"])
        draw.RoundedBox(0, 20, 500, 560, 80, currentColors["money_btn"])
        
        draw.SimpleText("$" .. self:GetMoneyAmount(), OBTPRINT:Font(72, "Bold"), 300, 540, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        if OBTPRINT.imgui.IsHovering(15,495,570,90) then
            
            currentColors["money_btn"] = colors["slot_hover"]
            
            if OBTPRINT.imgui.IsPressed() then
                
                if CurTime() >= retrieveMoneyCooldown then 
                    
                    net.Start("OBTPRINT:ActionOnPrinter")
                    net.WriteUInt(4, 3)
                    net.WriteEntity(self)
                    net.SendToServer()
    
                    retrieveMoneyCooldown = CurTime() + 2
                    
                end

            end
            
        else
            currentColors["money_btn"] = colors["slot"]
        end

        -- Draw center logo
        surface.SetMaterial(OBTPRINT.Constants.materials["logo"])
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(225,275,150,150)
        
        if self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= 10000*OBTPRINT.Config.MinimalDistance then
            OBTPRINT.imgui.xCursor(0, 0, 600, 600)
        end
        
        OBTPRINT.imgui.End3D2D()

    end
    
end
