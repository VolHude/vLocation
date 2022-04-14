
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
        MarkerLocation()
    end
end)

local money = false

RegisterNetEvent('vLocation:true')
AddEventHandler('vLocation:true', function()
	money = true
end)

RegisterNetEvent('vLocation:false')
AddEventHandler('vLocation:false', function()
	money = false
end)

function OpenLocMenu(Location)
    local menuLoc = RageUI.CreateMenu("Location", "Location", nil, nil, nil, nil, 0, 0, 0, 0)
    RageUI.Visible(menuLoc, not RageUI.Visible(menuLoc))
    while menuLoc do
        Citizen.Wait(0)
        RageUI.IsVisible(menuLoc, function()
            for i = 1, #Location.Vehicule do
                local v = Location.Vehicule[i] 
               RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true,               
               {
					onSelected = function()
                        TriggerServerEvent('vLocation:Check', v.price)
                        Citizen.Wait(500)
                     if  money == true then
                        TriggerServerEvent('vLocation:Prize', v.label, v.price)
                        local model = GetHashKey(v.model)
                        RequestModel(v.model)
                        while not HasModelLoaded(v.model) do
                            RequestModel(v.model)
                            Citizen.Wait(200) 
                        end
                        Vehicle = CreateVehicle(v.model, v.PosSpawner.x, v.PosSpawner.y, v.PosSpawner.z, v.h, true, false)
                        SetPedIntoVehicle(GetPlayerPed(-1),Vehicle,-1)
                        SetEntityAsNoLongerNeeded(Vehicle)
                        SetVehicleNumberPlateText (Vehicle, "Location")
                        SetPedIntoVehicle(GetPlayerPed(-1),Vehicle,-1)
                        RageUI.GoBack()
                     elseif money == false then
                    end
                    end,
				})
            end
        end)
        if not RageUI.Visible(menuLoc) then
            FreezeEntityPosition(PlayerPedId(), false)
            menuLoc = RMenu:DeleteType("menuLoc", true)
        end
    end
end



function MarkerLocation()
    Location = true
    Citizen.CreateThread(function()
        while Location do
            local InZone = false
            local playerPos = GetEntityCoords(PlayerPedId())
            for i = 1, #Config.Location do
                local v = Config.Location[i]

                                      local dst1 = GetDistanceBetweenCoords(playerPos, v.PosMenu, true)
                                      if dst1 < 5.0 then
                                          InZone = true
                                          DrawMarker(6, v.PosMenu.x, v.PosMenu.y, v.PosMenu.z -0.98, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 200, 0, 1, 2, 0, nil, nil, 0)
                                          if dst1 < 2.0 then
                                               ESX.ShowHelpNotification(v.HelpNotif)
                                              if IsControlJustReleased(1, 38) then
                                                  FreezeEntityPosition(PlayerPedId(), true)
                                                  OpenLocMenu(v)
                                              end
                       end
                  end
                local dst2 = GetDistanceBetweenCoords(playerPos, v.PosDeleter, true)
                if dst2 < 5.0 then
                    InZone = true
                    DrawMarker(6, v.PosDeleter.x, v.PosDeleter.y, v.PosDeleter.z -0.98, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 200, 0, 1, 2, 0, nil, nil, 0)
                    if dst2 < 2.0 then
                        ESX.ShowHelpNotification("Appuyez sur [~b~E~s~] pour ~r~Rendre~s~ la location")
                        if IsControlJustReleased(1, 38) then
                            local Vehicule = ESX.Game.GetClosestVehicle({x = playerPos.x, y = playerPos.y, z = playerPos.z})
                            print(Vehicule)
                            local HashVehicule = GetEntityModel(Vehicule)
                            DeleteEntity(Vehicule)
                            ESX.ShowNotification("Vous avez ~r~rendu~s~ la location")
                        end
                    end
                    end
                end
            if not InZone then
                Wait(500)
            else
                Wait(1)
            end
        end
    end)
end
