--------------------------------------------
------ Napisane przez wojtek.cfg#0349 ------
----------------- ©  2019 ------------------
--------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('wojtek_kurier:hajszanormalna')
AddEventHandler('wojtek_kurier:hajszanormalna', function()

	local wyp1 = Config.Wyplata1
	local wyp2 = Config.Wyplata2
	local wypsuma = math.random(wyp1,wyp2)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addMoney(wypsuma)
	TriggerClientEvent("pNotify:SendNotification", source,{
		text = "Dostarczyłeś <b style='color:#007b02'>nieuszkodzoną</b> paczkę, zarobiłeś: <b style='color:#00ea02'>"..wypsuma.."$</b>",
		type = "success",
		timeout = (2000),
		layout = "bottomCenter",
		queue = "kurier",
		animation = {
		open = "gta_effects_fade_in",
		close = "gta_effects_fade_out"
	}})

end)

RegisterServerEvent('wojtek_kurier:hajszauszkodzone')
AddEventHandler('wojtek_kurier:hajszauszkodzone', function()

	local uszk1 = Config.Uszkodzone1
	local uszk2 = Config.Uszkodzone2
	local uszksuma = math.random(uszk1,uszk2)

    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addMoney(uszksuma)
	TriggerClientEvent("pNotify:SendNotification", source,{
		text = "Dostarczyłeś <b style='color:#ff0000'>uszkodzoną</b> paczkę, zarobiłeś: <b style='color:#f3b900'>"..uszksuma.."$</b>",
		type = "success",
		timeout = (2000),
		layout = "bottomCenter",
		queue = "kurier",
		animation = {
		open = "gta_effects_fade_in",
		close = "gta_effects_fade_out"
	}})

end)


--------------------------------------------
------ Napisane przez wojtek.cfg#0349 ------
----------------- ©  2019 ------------------
--------------------------------------------



