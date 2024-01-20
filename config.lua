Config = {}

Config.Debug = false     -- Debug Mode To Print Stuff

Config.CopsReq = 2      -- Min Police To Do A Red USB Hack

Config.AmountToGive = 5     -- This Is How Many Items From The CrateItems Table To Give So This Will Give 5 Total Items

Config.RedCoords = {        -- This Is Possible Crate Locations
    vector3(-66.93, 1895.16, 196.17),
}

Config.CrateItems = {       -- Items From The Crate
    "steel",
    "steel",
    "steel",
    "steel",
    "steel",
}

Config['redguards'] = {     -- Guards That Spawn Around The Crate
    ['guards'] = {
        { coords = vector3(1439.06, 6320.65, 24.28), heading = 38.41, model = 'csb_mweather'},
        { coords = vector3(1453.0, 6338.79, 23.81), heading = 94.02, model = 'csb_mweather'},
        { coords = vector3(1474.68, 6372.33, 23.6), heading = 345.89, model = 'csb_mweather'},
        { coords = vector3(1484.32, 6368.98, 23.7), heading = 120.9, model = 'csb_mweather'},
        { coords = vector3(1426.31, 6357.93, 28.4), heading = 173.16, model = 'csb_mweather'},
        { coords = vector3(1424.21, 6356.38, 23.98), heading = 184.4, model = 'csb_mweather'},
        { coords = vector3(1425.87, 6347.98, 23.98), heading = 179.2, model = 'csb_mweather'},
        { coords = vector3(1441.03, 6336.22, 23.85), heading = 71.62, model = 'csb_mweather'},
        { coords = vector3(1433.11, 6330.34, 23.99), heading = 48.6, model = 'csb_mweather'},
        { coords = vector3(1088.1405, -2246.9199, 37.6795), heading = 201.0654, model = 'csb_mweather'},
        { coords = vector3(1108.3584, -2320.5750, 36.5850), heading = 44.2218, model = 'csb_mweather'},
        { coords = vector3(1077.6124, -2307.5488, 38.7956), heading = 295.8649, model = 'csb_mweather'},
    },
}