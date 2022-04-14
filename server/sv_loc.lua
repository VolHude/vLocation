
ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('vLocation:Check')
AddEventHandler('vLocation:Check', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getMoney()	
    if xMoney >= price then
		TriggerClientEvent('vLocation:true', source)
	else
		TriggerClientEvent('vLocation:false', source)
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez assez ~r~d\'argent")
	end
end)

RegisterNetEvent('vLocation:Prize')
AddEventHandler('vLocation:Prize', function(item,price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('esx:showNotification', source, "~g~Vous Venez de Louer une "..item.." Pour "..price.."$")
    else
         TriggerClientEvent('esx:showNotification', source, "Vous n'avez assez ~r~d\'argent")
    end
end)
