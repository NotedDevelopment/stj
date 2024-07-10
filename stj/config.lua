Config = {}

Config.StartLocation = vector4(2339.44, 3051.93, 48.15, 273.39)
Config.SellLocation = vector4(2343.44, 3051.93, 48.15, 273.39)

Config.ScrapTime = 2000
Config.HoodScrapAnimation = 'mini@repair'
Config.DoorScrapAnimation = 'amb@world_human_welding@male@base'
Config.EnableChopCard = false
Config.Testing = true

Config.SellableItems = {
    {itemName = "metalscrap", paymentType = "cash", price = 100},
    {itemName = "plastic", paymentType = "loosenotes", price = 25},
    {itemName = "copper", paymentType = "loosenotes", price = 10},
    {itemName = "glass", paymentType = "loosenotes", price = 30},
    {itemName = "rubber", paymentType = "cash", price = 50},
}
