ServerFunctions = {}

ServerFunctions.CheckOffDuty = function(JobName, src)
    local Players = QBCore.Functions.GetQBPlayers()
    -- Iterate over all jobs and insert them as false
    for k,v in pairs(Players) do
        if v.PlayerData.job.name == JobName and v.PlayerData.source ~= src then
            -- Check if player is onduty
            if v.PlayerData.job.onduty then
                return true
            end
        end
    end

    return false
end

ServerFunctions.IsPlayerBoss = function(src, playerJob)
    local player = QBCore.Functions.GetPlayer(src)
    if player.PlayerData.job.name ~= playerJob then return false end

    for k,v in pairs(Config.BlipList[playerJob]["bossRanks"]) do
        if v == player.PlayerData.job.grade.name and player.PlayerData.job.onduty then
            return true
        end
    end
    return false
end

ServerFunctions.IsBossOnline = function(JobName)
    local Players = QBCore.Functions.GetQBPlayers()

    for k,v in pairs(Players) do
        if ServerFunctions.IsPlayerBoss(v.PlayerData.source, JobName) then
            return true
        end
    end

    return false
end

ServerFunctions.RefreshBlipsColors = function(playerJob)
    local currentColor = JobInformation[playerJob].color
    local newColor = ServerFunctions.GetRightBlipColor(playerJob, ServerFunctions.OnDutyMemberCount(playerJob))
    
    if newColor ~= currentColor then
        JobInformation[playerJob].color = newColor
        ServerFunctions.RefreshBlipsForJob(playerJob)
    end
end

ServerFunctions.RefreshBlipsForJob = function(JobName)
    local Players = QBCore.Functions.GetQBPlayers()

    for k,v in pairs(Players) do
        TriggerClientEvent("gp_dutyBlips:refreshBlipsForJob", k, JobName, JobInformation[JobName])
    end
end

ServerFunctions.OnDutyMemberCount = function(JobName)
    local Players = QBCore.Functions.GetQBPlayers()
    local onDutyPlayers = 0
    for k,v in pairs(Players) do
        local player = QBCore.Functions.GetPlayer(k)
        if player.PlayerData.job.name == JobName and player.PlayerData.job.onduty then
            onDutyPlayers = onDutyPlayers + 1
        end
    end
    return onDutyPlayers
end

ServerFunctions.GetRightBlipColor = function(JobName, MemberCount)
    local blipColors = Config.BlipList[JobName].blipColors
    local validColor = tonumber(blipColors[1])

    for color, neededMembers in pairs(blipColors) do
        if MemberCount >= neededMembers then
            validColor = tonumber(color)
        end
    end

    return validColor
end

ServerFunctions.RefreshAllBlipsAllJobs = function()
    for k,v in pairs(Config.BlipList) do
        local memberCount = ServerFunctions.OnDutyMemberCount(k)
        JobInformation[k] = {
            color = ServerFunctions.GetRightBlipColor(k, memberCount),
            member = memberCount,
            showTick = ServerFunctions.IsBossOnline(k),
            blockRefresh = true
        }
    end

    local Players = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(Players) do
        TriggerClientEvent("gp_dutyBlips:SetBlips", k, JobInformation)
    end

    for k,v in pairs(JobInformation) do
        v.blockRefresh = false
    end
end