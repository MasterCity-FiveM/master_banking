ESX                         = nil
inMenu                      = false
local showblips = true
local atbank = true
local anim = "mini@atmenter"
local modeltypes = {'prop_fleeca_atm', 'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}

local banks = {
  {name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
  {name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
  {name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=108, x=241.727, y=220.706, z=106.286},
  {name="Bank", id=108, x=1175.0643310547, y=2706.6435546875, z=38.094036102295}
}	

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('master_keymap:e')
AddEventHandler('master_keymap:e', function()
	if not inMenu then
		playerPed = PlayerPedId()
		IsPlayerInVehicle = IsPedInAnyVehicle(playerPed, true)
		if not IsPlayerInVehicle then
			local IsPlayerNearAtm = false
			x,y,z = table.unpack(GetEntityCoords(playerPed, true))
			for k,v in pairs(modeltypes) do
				atm = GetClosestObjectOfType(x, y, z, 1.75, GetHashKey(v), false)
				if DoesEntityExist(atm) then
					currentAtm = atm
					atmX, atmY, atmZ = table.unpack(GetOffsetFromEntityInWorldCoords(currentAtm, 0.0, -0.65, 0.0))
					IsPlayerNearAtm = true
				end
			end
			
			if IsPlayerNearAtm then
				TriggerEvent("masterking32:closeAllUI")
				Citizen.Wait(100)
				inMenu = true
				Citizen.CreateThread(function()
					while inMenu do
						Wait(0)
						DisableControlAction(0, 201, true)
						DisableControlAction(1, 201, true)	
					end
				end)
				
				RequestAnimDict("mini@atmbase")		
				RequestAnimDict(anim)
				while not HasAnimDictLoaded(anim) do
					Wait(1)
				end

				SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"), true)
				TaskLookAtEntity(playerPed, currentAtm, 2000, 2048, 2)
				Wait(500)
				TaskGoStraightToCoord(playerPed, atmX, atmY, atmZ, 0.1, 4000, GetEntityHeading(currentAtm), 0.5)
				Wait(2000)
				TaskPlayAnim(playerPed, anim, "enter", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
				RemoveAnimDict(animDict)
				Wait(4000)
				TaskPlayAnim(playerPed, "mini@atmbase", "base", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
				RemoveAnimDict("mini@atmbase")				
				Wait(1000)
				PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
				FreezeEntityPosition(playerPed, true)

				SetNuiFocus(true, true)
				SendNUIMessage({type = 'openGeneral'})
				TriggerServerEvent('bank:balance')
			end
		end
	end
end)

RegisterNetEvent('master_keymap:esc')
AddEventHandler('master_keymap:esc', function() 
	if inMenu then
		FreezeEntityPosition(PlayerPedId(), false)
		PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		inMenu = false
		SetNuiFocus(false, false)
		SendNUIMessage({type = 'closeAll'})
	end
end)

RegisterNetEvent('masterking32:closeAllUI')
AddEventHandler('masterking32:closeAllUI', function() 
	FreezeEntityPosition(PlayerPedId(), false)
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)

AddEventHandler('esx:onPlayerDeath', function()
	if inMenu then
		FreezeEntityPosition(PlayerPedId(), false)
		-- PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		inMenu = false
		SetNuiFocus(false, false)
		SendNUIMessage({type = 'closeAll'})
	end
end)

--===============================================
--==             Map Blips	                   ==
--===============================================
Citizen.CreateThread(function()
	if showblips then
	  for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 1.0)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	  end
	end
end)

RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
	})
end)

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit', tonumber(data.amount))
end)

RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdraw', tonumber(data.amountw))
end)

RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transfer', data.to, data.amountt)
end)

RegisterNUICallback('NUIFocusOff', function()
  FreezeEntityPosition(PlayerPedId(), false)
  PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end