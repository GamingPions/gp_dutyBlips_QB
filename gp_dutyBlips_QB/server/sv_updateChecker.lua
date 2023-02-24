UpdateChecker = {}

UpdateChecker.checkForUpdate = function()
    local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version") 
    local currentVersionInt = tonumber(string.sub(currentVersion, 1, 1) .. string.sub(currentVersion, 3, 3) .. string.sub(currentVersion, 5, 5)) 
    local resourceName = "^4["..GetCurrentResourceName().."]^7"
    
    PerformHttpRequest('https://raw.githubusercontent.com/GamingPions/gp_resourcesVersions/main/gpScriptVersions.json', function(Error, NewestVersion, Header)
        local content = json.decode(NewestVersion)["gp_dutyBlips_QB"]
        local newestVersion = content["newestVersion"]
        local newestVersionInt = tonumber(string.sub(newestVersion, 1, 1) .. string.sub(newestVersion, 3, 3) .. string.sub(newestVersion, 5, 5)) 
    
        Config.debug("info", "-----------------------------------------------------------------------------------------------")
        -- check if current version is outdated
        if currentVersionInt < newestVersionInt then
            Config.debug("warning", resourceName .. " ^1Ressource is outdated!^7")
            Config.debug("warning", "^2Newest Version: " .. newestVersion .. "^7")
            Config.debug("warning", "^3Your Version: " .. currentVersion .. "^7")
            Config.debug("warning", "^5Please update as soon as possible by downloading the latest version from your keymaster!^7")

            if Config.showChangeLogsOnUpdateCheck then
                Config.debug("info", "")
                UpdateChecker.printChangelogs(content["changelogs"])
            end
        else
            Config.debug("success", resourceName .. " Ressource on version " .. currentVersion .. " is up-to-date!")
        end
        Config.debug("info", "-----------------------------------------------------------------------------------------------")
    end)
end

UpdateChecker.printChangelogs = function(changelogs)
    local isNew = ServerFunctions.getLengthOfArray(changelogs["new"])
    local fixedBugs = ServerFunctions.getLengthOfArray(changelogs["fix"])
    local anyChanges = ServerFunctions.getLengthOfArray(changelogs["changes"])
    
    if isNew > 0 or fixedBugs > 0 or anyChanges > 0 then
        Config.debug("info", "^4Latest Changelogs:^7")
    
        if isNew > 0 then
            Config.debug("info", "   ^2New Stuff:^7")
            for k,v in pairs(changelogs["new"]) do
                Config.debug("info", "    " .. v)
            end
        end
        if fixedBugs > 0 then
            Config.debug("info", "   ^2Bug-fixes:^7")
            for k,v in pairs(changelogs["fix"]) do
                Config.debug("info", "    " .. v)
            end
        end
        if anyChanges > 0 then
            Config.debug("info", "   ^2Changes:^7")
            for k,v in pairs(changelogs["changes"]) do
                Config.debug("info", "    " .. v)
            end
        end
    else
        Config.debug("info", "^4No Changelogs found!^7")
    end
end