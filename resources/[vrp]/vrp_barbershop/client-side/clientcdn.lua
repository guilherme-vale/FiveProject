-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_barbershop", cnVRP)
vSERVER = Tunnel.getInterface("vrp_barbershop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = -1
myClothes = {}
local canStartTread = 0

function f(n)
    n = n + 0.00000
    return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSkin", function(data)
	
	myClothes.skinColor = tonumber(data.skinColor)
	myClothes.eyesColor = tonumber(data.eyesColor)
    myClothes.complexionModel = tonumber(data.complexionModel)
    myClothes.blemishesModel = tonumber(data.blemishesModel)
    myClothes.frecklesModel = tonumber(data.frecklesModel)
    myClothes.ageingModel = tonumber(data.ageingModel)
    myClothes.hairModel = tonumber(data.hairModel)
    myClothes.firstHairColor = tonumber(data.firstHairColor)
    myClothes.secondHairColor = tonumber(data.secondHairColor)
    myClothes.makeupModel = tonumber(data.makeupModel)
    myClothes.lipstickModel = tonumber(data.lipstickModel)
    myClothes.lipstickColor = tonumber(data.lipstickColor)
    myClothes.eyebrowsModel = tonumber(data.eyebrowsModel)
    myClothes.eyebrowsColor = tonumber(data.eyebrowsColor)
    myClothes.beardModel = tonumber(data.beardModel)
    myClothes.beardColor = tonumber(data.beardColor)    
    myClothes.blushModel = tonumber(data.blushModel)
    myClothes.blushColor = tonumber(data.blushColor)

    if data.value then
        SetNuiFocus(false)
        displayBarbershop(false)
        vSERVER.updateSkin(myClothes)
        SendNUIMessage({
            openBarbershop = false
        })
    end

    updateHead()
    updateFace()
    updateGenetics()

end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATELEFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rotate", function(data, cb)
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    if data == "left" then
        SetEntityHeading(ped, heading + 10)
    elseif data == "right" then
        SetEntityHeading(ped, heading - 10)
    end
end)

--{"eyebrowsModel":16,"jawHeight":0,"eyebrowsWidth":0,"noseBridge":0,"chestColor":0,"complexionModel":-1,"neckWidth":0,"frecklesModel":-1,"skinColor":9,"blushColor":0,"cheekboneHeight":0,"eyebrowsColor":0,"chinLength":0,"cheekboneWidth":0,"sundamageModel":-1,"ageingModel":-1,"hairModel":4,"chinPosition":0,"firstHairColor":0,"noseShift":0,"noseTip":0,"chinWidth":0,"blemishesModel":-1,"beardColor":0,"noseWidth":0,"lipstickModel":-1,"makeupModel":-1,"lips":0,"noseHeight":0,"eyebrowsHeight":0,"secondHairColor":0,"blushModel":-1,"mothersID":24,"beardModel":-1,"jawWidth":0,"fathersID":4,"chestModel":-1,"lipstickColor":0,"shapeMix":0.7,"noseLength":0,"cheeksWidth":0,"chinShape":0,"eyesColor":0}
function updateGenetics()
    local data = myClothes
    local ped = PlayerPedId()    
    SetPedHeadBlendData(PlayerPedId(), tonumber(data.fathersID), tonumber(data.mothersID), 0, tonumber(data.skinColor), 0, 0, f(data.shapeMix), 0, 0, false)
    SetPedEyeColor(ped, data.eyesColor)
end

function updateFace()
    local ped = PlayerPedId()
    local data = myClothes
    -- Olhos
    -- Sobrancelha
    SetPedFaceFeature(ped, 6, tonumber(data.eyebrowsHeight))
    SetPedFaceFeature(ped, 7, tonumber(data.eyebrowsWidth))
    -- -- Nariz
    SetPedFaceFeature(ped, 0, tonumber(data.noseWidth))
    SetPedFaceFeature(ped, 1, tonumber(data.noseHeight))
    SetPedFaceFeature(ped, 2, tonumber(data.noseLength))
    SetPedFaceFeature(ped, 3, tonumber(data.noseBridge))
    SetPedFaceFeature(ped, 4, tonumber(data.noseTip))
    -- SetPedFaceFeature(ped, 5, data.noseShift)
    -- Bochechas
    SetPedFaceFeature(ped, 8, tonumber(data.cheekboneHeight))
    SetPedFaceFeature(ped, 9, tonumber(data.cheekboneWidth))
    SetPedFaceFeature(ped, 10, tonumber(data.cheeksWidth))
    -- -- Boca/Mandibula
    SetPedFaceFeature(ped, 12, tonumber(data.lips))
    SetPedFaceFeature(ped, 13, tonumber(data.jawWidth))
    SetPedFaceFeature(ped, 14, tonumber(data.jawHeight))
    -- -- Queixo
    SetPedFaceFeature(ped, 15, tonumber(data.chinLength))
    SetPedFaceFeature(ped, 16, tonumber(data.chinPosition))
    SetPedFaceFeature(ped, 17, tonumber(data.chinWidth))
    SetPedFaceFeature(ped, 18, tonumber(data.chinShape))
    -- -- Pescoço
    SetPedFaceFeature(ped, 19, tonumber(data.neckWidth))

end

function updateHead()
    local ped = PlayerPedId()
    local data = myClothes
    -- sobrancelhas
    SetPedHeadOverlay(ped, 2, data.eyebrowsModel, 0.99)
    SetPedHeadOverlayColor(ped, 2, 1, data.eyebrowsColor, data.eyebrowsColor)
    -- Cabelo
    SetPedComponentVariation(ped, 2, tonumber(data.hairModel), 0, 0)
    SetPedHairColor(ped, tonumber(data.firstHairColor), tonumber(data.secondHairColor))
    -- -- Barba
    SetPedHeadOverlay(ped, 1, tonumber(data.beardModel), 0.99)
    SetPedHeadOverlayColor(ped, 1, 1, tonumber(data.beardColor), tonumber(data.beardColor))
    -- -- Pelo Corporal
    SetPedHeadOverlay(ped, 10, tonumber(data.chestModel), 0.99)
    SetPedHeadOverlayColor(ped, 10, 1, tonumber(data.chestColor), tonumber(data.chestColor))
    -- -- Maquiagem
    SetPedHeadOverlay(ped, 4, tonumber(data.makeupModel), 0.99)
    SetPedHeadOverlayColor(ped, 4, 0, 0, 0)
    -- -- Blush
    SetPedHeadOverlay(ped, 5, tonumber(data.blushModel), 0.99)
    SetPedHeadOverlayColor(ped, 5, 2, tonumber(data.blushColor), tonumber(data.blushColor))
    -- -- Battom
    SetPedHeadOverlay(ped, 8, tonumber(data.lipstickModel), 0.99)
    SetPedHeadOverlayColor(ped, 8, 2, tonumber(data.lipstickColor), tonumber(data.lipstickColor))

    -- Manchas
    SetPedHeadOverlay(ped, 0, tonumber(data.blemishesModel), 0.99)
    SetPedHeadOverlayColor(ped, 0, 0, 0, 0)
    -- Envelhecimento
    SetPedHeadOverlay(ped, 3, tonumber(data.ageingModel), 0.99)
    SetPedHeadOverlayColor(ped, 3, 0, 0, 0)
    -- Aspecto
    SetPedHeadOverlay(ped, 6, tonumber(data.complexionModel), 0.99)
    SetPedHeadOverlayColor(ped, 6, 0, 0, 0)
    -- Pele
    SetPedHeadOverlay(ped, 7, tonumber(data.sundamageModel), 0.99)
    SetPedHeadOverlayColor(ped, 7, 0, 0, 0)
    -- Sardas
    SetPedHeadOverlay(ped, 9, tonumber(data.frecklesModel), 0.99)
    SetPedHeadOverlayColor(ped, 9, 0, 0, 0)

end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_barbershop:setCustomization")
AddEventHandler("vrp_barbershop:setCustomization", function(dbCharacter)
    myClothes = dbCharacter	
    canStartTread = 20
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if canStartTread > 0 then
			while not IsPedModel(PlayerPedId(),"mp_m_freemode_01") and not IsPedModel(PlayerPedId(),"mp_f_freemode_01") do
				Citizen.Wait(10)
			end
            updateHead()
            updateFace()
            updateGenetics()
            canStartTread = canStartTread - 1
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPLAYBARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function displayBarbershop(enable)
    local ped = PlayerPedId()

    if enable then
        SetNuiFocus(true, true)
        SendNUIMessage({
            openBarbershop = true,
            myclothes = myClothes
        })

        FreezeEntityPosition(ped, true)

        if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then
            SendNUIMessage({
                type = "click"
            })
        end

        SetPlayerInvincible(ped, true)

        if not DoesCamExist(cam) then
            RenderScriptCams(false,true,250,1,0)
            DestroyCam(cam,false)
            cam = nil
        end

        SetEntityHeading(ped,240.0)
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
		SetCamActive(cam,true)
		RenderScriptCams(true,true,500,true,true)
		pos = GetEntityCoords(PlayerPedId())
		camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,0.5,0.0)
		SetCamCoord(cam,camPos.x,camPos.y,camPos.z + 0.65)
		PointCamAtCoord(cam,pos.x,pos.y,pos.z + 0.65)
    else
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(ped, false)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    SetNuiFocus(false)
    SendNUIMessage({
        openBarbershop = false
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local locations = {{-1845.0988769531,-1213.1837158203,13.017148971558}}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    SetNuiFocus(false, false)

    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped) then
            local coords = GetEntityCoords(ped)
            for k, v in pairs(locations) do
                local distance = #(coords - vector3(v[1], v[2], v[3]))
                if distance <= 2.5 then
                    timeDistance = 4
                    --[[ DrawText3D(v[1], v[2], v[3], "~g~E~w~   BARBEARIA") ]]
                    if IsControlJustPressed(1, 38) and vSERVER.checkOpen() then
                        displayBarbershop(true)
                        SetEntityHeading(ped, 240.0)
                    end
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x, y, z, text)
	SetTextFont(4)
	SetTextCentre(1)
	SetTextEntry("STRING")
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z,0)
	DrawText(0.0,0.0)
	local factor = (string.len(text) / 375) + 0.01
	DrawRect(0.0,0.0125,factor,0.03,38,42,56,200)
	ClearDrawOrigin()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncarea")
AddEventHandler("syncarea", function(x, y, z, distance)
    ClearAreaOfVehicles(x, y, z, distance + 0.0, false, false, false, false, false)
    ClearAreaOfEverything(x, y, z, distance + 0.0, false, false, false, false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN BARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("opernBarberhop")
AddEventHandler("opernBarberhop", function()
    displayBarbershop(true)
    SetEntityHeading(ped, 332.21)
end)
