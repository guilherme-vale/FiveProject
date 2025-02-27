local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local userlogin = {}
 AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
 	if first_spawn then
 		local data = vRP.getUData(user_id,"vRP:spawnController")
 		local sdata = json.decode(data) or 0
 		if sdata then
 			Citizen.Wait(1000)
 			processSpawnController(source,sdata,user_id)
 		end
 	end
 end)

--[[ RegisterServerEvent("ks-CharacterSpawn")
AddEventHandler("ks-CharacterSpawn", function(source,user_id) 
	if user_id then
			local data = vRP.getUData(user_id,"spawnController")
			local sdata = json.decode(data) or 0
			if sdata then
				Citizen.Wait(1000)
				processSpawnController(source,sdata,user_id)
			end
	end

end) ]]

function processSpawnController(source,statusSent,user_id)
	if statusSent == 2 then
		if not userlogin[user_id] then
			userlogin[user_id] = true
			doSpawnPlayer(source,user_id,false)
		else
			doSpawnPlayer(source,user_id,true)
		end
	elseif statusSent == 1 or statusSent == 0 then
		userlogin[user_id] = true
		TriggerClientEvent("ks-character:characterCreate",source)
	end
end

RegisterServerEvent("ks-character:finishedCharacter")
AddEventHandler("ks-character:finishedCharacter",function(characterNome, characterSobrenome, characterAge,currentCharacterMode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.setUData(user_id,"currentCharacterMode",json.encode(currentCharacterMode))
		vRP.setUData(user_id,"vRP:spawnController",json.encode(2))
		-- vRP.varyExp(user_id,"physical","strength",650)
		vRP.execute("vRP/update_user_first_spawn",{ user_id = user_id, firstname = characterSobrenome, name = characterNome, age = characterAge })
		doSpawnPlayer(source,user_id,true)
	end
end)

function doSpawnPlayer(source,user_id,firstspawn)
	TriggerClientEvent("ks-character:normalSpawn",source,firstspawn)
	TriggerEvent("vrp_barbershop:init",user_id)	
	TriggerEvent("tattoos:init",source)
	SetTimeout(120000,function()
        TriggerClientEvent("checkcam",source,true)
    end)
end

RegisterCommand("cc", function(source)
	TriggerClientEvent("ks-character:characterCreate",source)
end)