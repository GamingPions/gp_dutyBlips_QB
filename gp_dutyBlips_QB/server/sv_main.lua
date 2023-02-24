QBCore = exports['qb-core']:GetCoreObject()
JobInformation = {}

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        if Config.useUpdateChecker then UpdateChecker.checkForUpdate() end

        Citizen.Wait(500)
        local Players = QBCore.Functions.GetQBPlayers()

        -- Iterate over all jobs and insert them as false
        for k,v in pairs(Config.BlipList) do
            local memberCount = ServerFunctions.OnDutyMemberCount(k)
            JobInformation[k] = {
                color = ServerFunctions.GetRightBlipColor(k, memberCount),
                member = memberCount,
                showTick = ServerFunctions.IsBossOnline(k),
                blockRefresh = false
            }
        end

        for k,v in pairs(Players) do
            TriggerClientEvent("gp_dutyBlips:SetBlips", k, JobInformation)
        end
    end
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job.name

    TriggerClientEvent("gp_dutyBlips:SetBlips", src, JobInformation)
    
    if player.PlayerData.job.onduty then
        JobInformation[playerJob].member = JobInformation[playerJob].member + 1
        if ServerFunctions.IsPlayerBoss(src, playerJob) then
            JobInformation[playerJob].showTick = true
        end
        ServerFunctions.RefreshBlipsColors(playerJob)
    end
end)

RegisterNetEvent('QBCore:ToggleDuty', function()
    local src = source
    -- wait for changes has been made to get up-to-date player
    Citizen.Wait(100)

    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job.name
    if Config.BlipList[playerJob] == nil then return end

    if player.PlayerData.job.onduty then
        JobInformation[playerJob].member = JobInformation[playerJob].member + 1
    else
        JobInformation[playerJob].member = JobInformation[playerJob].member - 1
    end

    JobInformation[playerJob].showTick = ServerFunctions.IsBossOnline(playerJob)
    ServerFunctions.RefreshBlipsColors(playerJob)
end)

RegisterNetEvent('QBCore:Server:OnJobUpdate', function(source, newJob)
    -- wait for changes has been made to get up-to-date player
    Citizen.Wait(500)
    ServerFunctions.RefreshAllBlipsAllJobs()
end)

-- Return number if player disconnects and owns control center
AddEventHandler('playerDropped', function(reason)
	local src = source
	local player = QBCore.Functions.GetPlayer(src)
	local playerJob = player.PlayerData.job.name
	
    if not ServerFunctions.CheckOffDuty(playerJob, src) then
        JobInformation[playerJob].member = JobInformation[playerJob].member - 1
        if JobInformation[playerJob] then
            JobInformation[playerJob].showTick = ServerFunctions.IsBossOnline(playerJob)
            ServerFunctions.RefreshBlipsColors(playerJob)
        end
    end
end)