Config = {}

Config.useDebug = true

Config.useUpdateChecker = true
Config.showChangeLogsOnUpdateCheck = true

Config.BlipList = {
    ["police"] = {
        blipColors = {
          -- color = members onduty - gets handled like >=
            [1] = 0,
            [3] = 1,
        },
        showTickIfBossIsOnline = true,
        -- ignored if showTickIfBossIsOnline is false
        bossRanks = { "Chief" },
        JobBlips = {
            {
                Blip = nil, -- do not touch this value!
                BlipCoord = vector3(778.6766, -185.6200, 74.2370),
                DisplayName = "Police",
                BlipSprite = 60,
                BlipScale = 0.8,
            },
            {
                Blip = nil, -- do not touch this value!
                BlipCoord = vector3(886.2299, -247.1048, 69.5890),
                DisplayName = "Police 2",
                BlipSprite = 60,
                BlipScale = 0.8,
            },
        }
    },
    ["ambulance"] = {
        blipColors = {
          -- color = members onduty - gets handled like >=
            [1] = 0,
            [3] = 1,
        },
        showTickIfBossIsOnline = true,
        -- ignored if showTickIfBossIsOnline is false
        bossRanks = { "Chief" },
        JobBlips = {
            {
                Blip = nil, -- do not touch this value!
                BlipCoord = vector3(648.4884, -88.3766, 74.6782),
                DisplayName = "Ambulance",
                BlipSprite = 61,
                BlipScale = 0.8,
            },
            {
                Blip = nil, -- do not touch this value!
                BlipCoord = vector3(734.3309, -143.7835, 74.7619),
                DisplayName = "Ambulance 2",
                BlipSprite = 61,
                BlipScale = 0.8,
            },
        }
    }
}

Config.debug = function(type, msg)
    if Config.useDebug then
       local messagePraefix

        if type == nil then
            messagePraefix = ""
        elseif type == "success" then
            messagePraefix = "^2[SUCCESS]^0"
        elseif type == "info" then
            messagePraefix = "^4[INFO]^0"
        elseif type == "warning" then
            messagePraefix = "^3[WARNING]^0"
        elseif type == "error" then
            messagePraefix = "^1[ERROR]^0"
        end

        print("[DEBUG] " .. messagePraefix .. " " .. msg)
    end
end