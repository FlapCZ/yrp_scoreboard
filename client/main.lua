------------------------------------------------------------
--------------------- yrp_scoreboard -----------------------
------------------------------------------------------------
--------------------- Created by Flap ----------------------
------------------------------------------------------------
----------------- YourRolePlay Development -----------------
----------- Thank you for using this scoreboard ------------
----- Regular updates and lots of interesting scripts ------
--------- discord -> https://discord.gg/hqZEXc8FSE ---------
------------------------------------------------------------
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local idVisable = true
ESX = nil
local PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.general_config_settings.es_extended, function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	if PlayerData == nil or PlayerData.job == nil then
		PlayerData = ESX.GetPlayerData()
    end

	Citizen.Wait(128)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)


Citizen.CreateThread(function()
	Citizen.Wait(3000) 


	SendNUIMessage({
		action = 'updateServerInfo',

		maxPlayers = GetConvarInt('sv_maxclients', 64),
		uptime = 'unknown',
		playTime = '00h 00m',
	})

	if Config.general_config_settings.job_grade_players then
		SendNUIMessage({
			action = 'updateJobGradeAndName',

			name = '<span style="font-size: 0.7vw"> | </span>Your name: ' ..GetPlayerName(playerId),
			jobName = ' Your job: ' ..PlayerData.job.label,
			jobGrade = '<span style="font-size: 0.7vw"> | </span> Your job grade: ' ..PlayerData.job.grade_label.. ' <span style="font-size: 0.7vw"> | </span>'
		})
	end
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:updatePing')
AddEventHandler('esx_scoreboard:updatePing', function(connectedPlayers)
	SendNUIMessage({
		action  = 'updatePing',
		players = connectedPlayers
	})
end)

RegisterNetEvent('esx_scoreboard:toggleID')
AddEventHandler('esx_scoreboard:toggleID', function(state)
	if state then
		idVisable = state
	else
		idVisable = not idVisable
	end

	SendNUIMessage({
		action = 'toggleID',
		state = idVisable
	})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = uptime
	})
end)

function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList, num = {}, 1
    local players = 0

	for k,v in pairs(connectedPlayers) do

		if num == 1 then
			table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
			num = 2
		elseif num == 2 then
			table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
			num = 3
		elseif num == 3 then
			table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
			num = 4
		elseif num == 4 then
			table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.id, v.ping))
			num = 1
		end

		players = players + 1

		if Config.general_config_settings.active_ems then
	        if v.job == 'ambulance' then
				ems = "<i><div class='jobs ems fas fa-ambulance'></div></i>"
			else
				ems = ("<i><div class='jobsisnotonline ems fas fa-ambulance'></div></i>")
			end
		end

		if Config.general_config_settings.active_police then
		    if v.job == 'police' then
				police = "<i><div class='jobs pd fas fa-bullhorn'></i>"
			else
				police = ("<i><div class='jobsisnotonline pd fas fa-bullhorn'></div></i>")
			end
		end

		if Config.general_config_settings.active_taxi then
		    if v.job == 'taxi' then
			    taxi = "<i><div class='jobs taxi fas fa-taxi'></div></i>"
			else
				taxi = ("<i><div class='jobsisnotonline taxi fas fa-taxi'></div></i>")
			end
		end

		if Config.general_config_settings.active_mechanic then
		    if v.job == 'mechanic' or v.job == 'bennys' then
				mechanic = "<i><div class='jobs mech fas fa-wrench'></div></i>"
			else
				mechanic = ("<i><div class='jobsisnotonline mech fas fa-wrench'></div></i>")
			end
		end

		if Config.general_config_settings.active_miner then
		    if v.job == 'miner' then
				miner = "<i><div class='jobs miner far fa-gem'></div></i>"
			else
				miner = ("<i><div class='jobsisnotonline miner far fa-gem'></div></i>")
			end
		end

		if Config.general_config_settings.active_farmer then
		    if v.job == 'farmer' then
				farmer = "<i><div class='jobs farmer fas fa-tractor'></div></i>"
			else
				farmer = ("<i><div class='jobsisnotonline farmer fas fa-tractor'></div></i>")
			end
		end

		if Config.general_config_settings.active_fisherman then
		    if v.job == 'fisherman' then
				fisherman = "<i><div class='jobs fisherman fas fa-fish'></div></i>"
			else
				fisherman = ("<i><div class='jobsisnotonline fisherman fas fa-fish'></div></i>")
			end
		end

		if Config.general_config_settings.active_trucker then
		    if v.job == 'trucker' then
				trucker = "<i><div class='jobs trucker fas fa-truck'></div></i>"
			else
				trucker = ("<i><div class='jobsisnotonline trucker fas fa-truck'></div></i>")
			end
		end

		if Config.general_config_settings.illegal_actions then
			if v.job == 'police' then
				text = '<div class="illegal_actions"><h2> illegal actions are <i class="fas fa-check-circle"></i> </h2></div>'
			else
				text = '<div class="illegal_actions"><h2> illegal actions are <i class="fas fa-times-circle"></i> </h2></div>'
			end
		end

	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	SendNUIMessage({
		action  = 'updatePlayerList',
		players = table.concat(formattedPlayerList)
	})

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {ems = ems, police = police, taxi = taxi, mechanic = mechanic, miner = miner, farmer = farmer, fisherman = fisherman, trucker = trucker, player_count = players}
	})

	SendNUIMessage({
		action  = 'updateIllegalActions',
		text    = {text = text}
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased(0, Keys['DELETE']) and IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(100)

		-- D-pad up on controllers works, too!
		elseif IsControlJustReleased(0, 172) and not IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(200)
		end
	end
end)

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({
				action  = 'close'
			})
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(2000 * 60) -- every minute
		playMinute = playMinute + 1
	
		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updateServerInfo',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)
