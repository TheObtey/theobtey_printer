OBTPRINT.Config = OBTPRINT.Config or {}

-- What language use (fr, en)
OBTPRINT.Config.Language = "en"

-- Distance min to interact with printer (in meter)
OBTPRINT.Config.MinimalDistance = 1

if SERVER then
	
	-- Admin ranks
	OBTPRINT.Config.AdminRanks = {
		["superadmin"] = true,	
		["admin"] = true	
	}

	-- Interval between each print
	OBTPRINT.Config.IntervalBetweenPrint = 2

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

OBTPRINT.Config.Tiers = {
	[1] = {
		name = "BASIQUE",
		price = 0,
		printedMoney = 1000
	},
	[2] = {
		name = "INTERDMÉDIAIRE",
		price = 500,
		printedMoney = 5000
	},
	[3] = {
		name = "AVANCÉ",
		price = 1500,
		printedMoney = 10000
	}
}