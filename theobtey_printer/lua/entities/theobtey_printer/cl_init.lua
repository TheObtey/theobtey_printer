include("shared.lua")

local imgui = include("theobtey_printer/client/imgui.lua")

local colors = {
    ["bg"] = Color(42,42,42),
    ["border"] = Color(104,104,104),
    ["slot"] = Color(48,48,48),
    ["slot_hover"] = Color(38,38,38)
}

local currentColors = {
    ["battery_btn"] = colors["slot"],
    ["temperature_btn"] = colors["slot"],
    ["money_btn"] = colors["slot"]
}

OBTPRINT.Fonts = {}

-- Automatic responsive functions
local RX = RX or function(x) return x / 1920 * ScrW() end
local RY = RY or function(y) return y / 1080 * ScrH() end

-- Automatic font-creation function
function OBTPRINT:Font(iSize, sType, bNoResponsive)

    iSize = iSize or 15
    sType = sType or "Medium" -- Availables: Thin, Light, Medium, SemiBold, Bold, ExtraBold, Italic

    local sName = ("OBTPRINT:Font:%i:%s"):format(iSize, sType)
    if not OBTPRINT.Fonts[sName] then

        surface.CreateFont(sName, {
            font = ("K2D %s"):format(sType):Trim(),
            size = bNoResponsive and iSize or RX(iSize),
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

    if imgui.Start3D2D(self:LocalToWorld(Vector(-15.9,-14.8,10.97)), self:LocalToWorldAngles(Angle(0,90,-.13)), .05, 1000, 750) then
        
        -- Draw background
        draw.RoundedBox(0, 0, 0, 600, 600, colors["border"])
        draw.RoundedBox(0, 5, 5, 590, 590, colors["bg"])
        
        -- Draw player's name
        draw.RoundedBox(0, 15, 15, 570, 60, colors["border"])
        draw.RoundedBox(0, 20, 20, 560, 50, colors["slot"])
        
        draw.SimpleText(self:GetPrinterOwner(), OBTPRINT:Font(32, nil, false), 300, 42, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        -- Draw printer tier
        draw.RoundedBox(0, 15, 85, 570, 60, colors["border"])
        draw.RoundedBox(0, 20, 90, 560, 50, colors["slot"])
        
        draw.SimpleText(tostring(self:GetTier()), OBTPRINT:Font(32, nil, false), 300, 114, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)    
        
        -- Draw battery slot
        draw.RoundedBox(0, 15, 155, 160, 330, colors["border"])
        draw.RoundedBox(0, 20, 160, 150, 320, colors["slot"])
        draw.RoundedBox(0, 25, 434, 140, 40, colors["border"])
        draw.RoundedBox(0, 28, 437, 134, 34, currentColors["battery_btn"])
        
        draw.SimpleText("Batterie", OBTPRINT:Font(32, "Bold", false), 93, 185, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(self:GetBatteryCharge()).. "%", OBTPRINT:Font(24, "Thin", false), 95, 225, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("RECHARGER", OBTPRINT:Font(24, "SemiBold", false), 93, 455, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
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
        
        if imgui.IsHovering(25,434,140,40) then
            
            currentColors["battery_btn"] = colors["slot_hover"]
            
            if imgui.IsPressed() then
                
                net.Start("OBTPRINT:RechargeBattery")
                net.WriteEntity(self)
                net.SendToServer()
                
            end
            
        else
            currentColors["battery_btn"] = colors["slot"]
        end
        
        -- Draw temperature slot
        draw.RoundedBox(0, 425, 155, 160, 330, colors["border"])
        draw.RoundedBox(0, 430, 160, 150, 320, colors["slot"])
        draw.RoundedBox(0, 435, 434, 140, 40, colors["border"])
        draw.RoundedBox(0, 438, 437, 134, 34, currentColors["temperature_btn"])
        
        draw.SimpleText("Température", OBTPRINT:Font(32, "Bold", false), 505, 185, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(self:GetTemperature()) .. "°", OBTPRINT:Font(24, "Thin", false), 505, 225, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("REFROIDIR", OBTPRINT:Font(24, nil, false), 505, 455, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
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
        
        if imgui.IsHovering(435,434,140,40) then
            
            currentColors["temperature_btn"] = colors["slot_hover"]
            
            if imgui.IsPressed() then
                
                net.Start("OBTPRINT:CoolTemperature")
                net.WriteEntity(self)
                net.SendToServer()
                
            end
            
        else
            currentColors["temperature_btn"] = colors["slot"]
        end
        
        -- Draw money count
        draw.RoundedBox(0, 15, 495, 570, 90, colors["border"])
        draw.RoundedBox(0, 20, 500, 560, 80, currentColors["money_btn"])
        
        draw.SimpleText("$" .. self:GetMoneyAmount(), OBTPRINT:Font(72, "Bold", false), 300, 540, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        if imgui.IsHovering(15,495,570,90) then
            
            currentColors["money_btn"] = colors["slot_hover"]
            
            if imgui.IsPressed() then
                
                net.Start("OBTPRINT:RetrieveMoney")
                net.WriteEntity(self)
                net.SendToServer()
                
            end
            
        else
            currentColors["money_btn"] = colors["slot"]
        end

        -- Draw center logo
        surface.SetMaterial(OBTPRINT.Constants.materials["logo"])
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(225,225,150,150)
        
        imgui.xCursor(0, 0, 600, 600)
        imgui.End3D2D()
    end
    
end
