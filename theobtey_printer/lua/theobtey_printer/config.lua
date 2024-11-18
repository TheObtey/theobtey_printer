OBTPRINT.Config = OBTPRINT.Config or {}

-- What language use (fr, en)
OBTPRINT.Config.Language = "fr"

-- Leave blank to use DarkRP currency
OBTPRINT.Config.MoneyCurrency = "$"

-- Minimal distance to interact with printer (in meter)
OBTPRINT.Config.MinimalDistance = 1

if SERVER then
	
	-- Admin ranks
	OBTPRINT.Config.AdminRanks = {
		["superadmin"] = true,	
		["admin"] = true	
	}

	-- Interval between each print
	OBTPRINT.Config.IntervalBetweenPrint = 5

	-- How much money is printed
	OBTPRINT.Config.MoneyAmountPrinted = 1000

	-- How much to decrease battery for each print 
	OBTPRINT.Config.BatteryDecrease = 5

	-- Cost of a full battery recharge
	OBTPRINT.Config.BatteryRechargeCost = 100

	-- How much heat to increase for each print 
	OBTPRINT.Config.TemperatureIncrease = 5

	-- Cost of a full cooling
	OBTPRINT.Config.TemperatureCoolCost = 100

end

-- Tiers for printers
OBTPRINT.Config.Tiers = {
	[1] = {
		name = "BASIC",		-- Name of the tier
		price = 0,		-- Price for the upgrade
		printedMoney = 1000	-- Money amount to print
	},
	[2] = {
		name = "INTERMEDIATE",
		price = 500,
		printedMoney = 5000
	},
	[3] = {
		name = "ADVANCED",
		price = 1500,
		printedMoney = 10000
	}
}
