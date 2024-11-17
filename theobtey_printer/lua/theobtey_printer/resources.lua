OBTPRINT.Constants = {}

-- Materials constants
OBTPRINT.Constants["materials"] = {
	["logo"] = Material("theobtey_printer/logo.png"),
	["battery"] = {
		["0"] = Material("theobtey_printer/battery/0.png"),
		["10"] = Material("theobtey_printer/battery/10.png"),
		["20"] = Material("theobtey_printer/battery/20.png"),
		["50"] = Material("theobtey_printer/battery/50.png"),
		["80"] = Material("theobtey_printer/battery/80.png"),
		["100"] = Material("theobtey_printer/battery/100.png")
	},
	["temperature"] = { 
		["50"] = Material("theobtey_printer/temperature/50.png"),
		["80"] = Material("theobtey_printer/temperature/80.png"),
		["100"] = Material("theobtey_printer/temperature/100.png")
	}
}

OBTPRINT.Constants["texts"] = {
	["fr"] = {
		["upgrade"] = "AMÉLIORER",
		["battery"] = "Batterie",
		["battery_charge"] = "RECHARGER",
		["temperature"] = "Température",
		["temperature_cool"] = "REFROIDIR"
	},

	["en"] = {
		["upgrade"] = "UPGRADE",
		["battery"] = "Battery",
		["battery_charge"] = "RECHARGE",
		["temperature"] = "Temperature",
		["temperature_cool"] = "COOL"
	},
}