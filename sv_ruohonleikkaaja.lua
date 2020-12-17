ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ruohonleikkuri:maksu')
AddEventHandler('ruohonleikkuri:maksu', function(raha)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(raha)
	TriggerClientEvent("ruohonleikkuri:maksu", source, raha)
end)