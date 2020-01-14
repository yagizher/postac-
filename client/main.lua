--------------------------------------------
------ Napisane przez wojtek.cfg#0349 ------
----------------- ©  2019 ------------------
--------------------------------------------

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

-- NIE DOTYKAJ POD WARUNKIEM ŻE WIESZ CO ROBISZ ! -- 
-- NIE DOTYKAJ POD WARUNKIEM ŻE WIESZ CO ROBISZ ! -- 
-- NIE DOTYKAJ POD WARUNKIEM ŻE WIESZ CO ROBISZ ! -- 
-- NIE DOTYKAJ POD WARUNKIEM ŻE WIESZ CO ROBISZ ! -- 
-- NIE DOTYKAJ POD WARUNKIEM ŻE WIESZ CO ROBISZ ! -- 
-- NIE DOTYKAJ POD WARUNKIEM ŻE WIESZ CO ROBISZ ! -- 
 


ESX                           = nil

local Akt         			  = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local JestWMarkerze 		  = false
local OstStrefa               = nil
local Czaspozostaly			  = 0
local PlayerData              = {}

local onDuty 				  = false
local wypozyczyljuzpojazd	  = false
local manotewarning 		  = false
local odebraljuzpaczke 		  = false
local otrzymalkoordynatydomu  = false
local cap = false

local uszkodzonepaczki = 0
local iloscpaczek = 0
local magazynx = 0
local magazyny = 0
local domx = 0
local domy = 0
local domz = 0

local dmgpoj = 0
local szybst = 0

-- #### Wątki #### -- 
--
Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
 	PlayerData = ESX.GetPlayerData()
  end
  	odswiezblipy()
end)
--
Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
		if Akt ~= nil then
  
	  SetTextComponentFormat('STRING')
	  AddTextComponentString(CurrentActionMsg)
	  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  
		  if IsControlPressed(0,  Keys['E']) then
			  --
			  if Akt == 'przeb' then
			  MenuPrzebieralnia()
			  end
			  --
			  if Akt == 'wypo' then
				  TriggerEvent('wojtek_kurier:rozpocznijprace')
			  end
			  --
			  if Akt == 'oddaj' then
				  Usunpojazdy()
			  end
			  --
			  if Akt == 'maga' then
				  odebralpaczkezmagazynuniebomusiszsobietakdorabiacboniemasznormalnejpracylmao()
			  end
			  --
			  if Akt == 'wet435' then
				  if cap == false then
					  cap = true
				  if iloscpaczek > 1 then
					  TriggerServerEvent('wojtek_kurier:hajszanormalna')
					  iloscpaczek = iloscpaczek - 1
					  wylosujdom()
					  Wait(2000)
					  cap = false
				  elseif uszkodzonepaczki > 1 then
					  TriggerServerEvent('wojtek_kurier:hajszauszkodzone')
					  uszkodzonepaczki = uszkodzonepaczki - 1
					  wylosujdom()
					  Wait(2000)
					  cap = false
				  elseif iloscpaczek == 1 then
					  TriggerServerEvent('wojtek_kurier:hajszanormalna')
					  iloscpaczek = iloscpaczek - 1
					  odebraljuzpaczke = false
					  RemoveBlip(blipdomu)
					  namagzyngo()
					  powiadom()
					  cap = false
				  elseif uszkodzonepaczki == 1 then
					  TriggerServerEvent('wojtek_kurier:hajszauszkodzone')
					  uszkodzonepaczki = uszkodzonepaczki - 1
					  odebraljuzpaczke = false
					  RemoveBlip(blipdomu)
					  namagzyngo()
					  powiadom()
					  cap = false
				  end
			  end
			  end
			  --
		  end
		end
	end
  end)
--
  Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local aktpojazd = GetVehiclePedIsIn(PlayerPedId(), false)
		if DoesEntityExist(aktpojazd) then
				local aktdmg = GetVehicleBodyHealth(aktpojazd)
				if aktdmg ~= dmgpoj then
					if (aktdmg < dmgpoj) and ((dmgpoj - aktdmg) >= 25) then
						utratapaczki()
					end
					dmgpoj = aktdmg
				end
			
				local aktprd = GetEntitySpeed(aktpojazd) * 2.23
				if aktprd ~= szybst then
					if (aktprd < szybst) and ((szybst - aktprd) >= 35) then
						utratapaczki()
					end
					szybst = aktprd
				end
		else
			dmgpoj = 0
			szybst = 0
		end
	end
end)
--
  Citizen.CreateThread(function ()
	while true do
	  Wait(0)
  
	  local coords = GetEntityCoords(GetPlayerPed(-1))
		for k,v in pairs(Config.StrefaPrzebieralnia) do
		  if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 100.0) and PlayerData.job ~= nil and PlayerData.job.name == 'kurier' then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 300, false, true, 2, false, false, false, false)
		  end
		end
  
		for k,v in pairs(Config.Strf2) do
		  if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 100.0) and PlayerData.job ~= nil and PlayerData.job.name == 'kurier' and onDuty == true and wypozyczyljuzpojazd == true then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 300, false, true, 2, false, false, false, false)
		  end
		end
  
		for k,v in pairs(Config.Strf1) do 
		  if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 100.0) and PlayerData.job ~= nil and PlayerData.job.name == 'kurier' and onDuty == true then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 300, false, true, 2, false, false, false, false)
		  end
		end
  
		for k,v in pairs(Config.Strf3) do 
		  if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 100.0) and PlayerData.job ~= nil and PlayerData.job.name == 'kurier' and onDuty == true and wypozyczyljuzpojazd == true and odebraljuzpaczke == false then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 300, false, true, 2, false, false, false, false)
		  end
		end
  
		  if GetDistanceBetweenCoords(coords, domx, domy, domz, true) < 100.0 and PlayerData.job ~= nil and PlayerData.job.name == 'kurier' and onDuty == true and wypozyczyljuzpojazd == true and otrzymalkoordynatydomu == true then
			DrawMarker(25, domx, domy, domz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 50, 50, 500, false, true, 2, false, false, false, false)
		  end
  
  
	end
  end)
--
Citizen.CreateThread(function ()
	while true do
	  Wait(0)
  
	  local coords      = GetEntityCoords(GetPlayerPed(-1))
	  local isInMarker  = false
	  local currentZone = nil
  
			  for k,v in pairs(Config.StrefaPrzebieralnia) do
				  if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				  isInMarker  = true
				  currentZone = k
				  end
			  end
	  
			  for k,v in pairs(Config.Strf2) do
				  if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				  isInMarker  = true
				  currentZone = k
				  end
			  end
  
			  for k,v in pairs(Config.Strf1) do
				  if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				  isInMarker  = true
				  currentZone = k
				  end
			  end
  
			  for k,v in pairs(Config.Strf3) do
				  if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				  isInMarker  = true
				  currentZone = k
				  end
			  end
  
			  if(GetDistanceBetweenCoords(coords, domx, domy, domz, true) < 1.5) then
				  isInMarker  = true
				  currentZone = k
				  zone = Klient
				  end
  
	  if (isInMarker and not JestWMarkerze) or (isInMarker and OstStrefa ~= currentZone) then
		JestWMarkerze = true
		OstStrefa                = currentZone
		TriggerEvent('wojtek_kurier:wmarkerze', currentZone)
	  end
  
	  if not isInMarker and JestWMarkerze then
		TriggerEvent('wojtek_kurier:pozamarkerem', OstStrefa)
		JestWMarkerze = false
		ESX.UI.Menu.CloseAll()
	  end
	end
  end)
----------------------------------

-- #### Eventy #### --
--
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
  	odswiezblipy()
end)
--
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  	odswiezblipy()
end)
--
AddEventHandler('wojtek_kurier:wmarkerze', function (zone)
	local coords = GetEntityCoords(GetPlayerPed(-1))
  if zone == 'Przebieralnia' and PlayerData.job ~= nil and PlayerData.job.name == 'kurier' then
    Akt	  = 'przeb'
	CurrentActionMsg  = ('Kliknij ~INPUT_CONTEXT~ aby się ~b~przebrać~w~')
	CurrentActionData = {}

  elseif zone == 'wypozyczpojazd' and onDuty == true then
    Akt	  = 'wypo'
	CurrentActionMsg  = ('Kliknij ~INPUT_CONTEXT~ aby ~b~wypożyczyć~w~ pojazd firmowy')
	CurrentActionData = {}

  elseif zone == 'oddajpojazd' and onDuty == true and wypozyczyljuzpojazd == true then
    Akt	  = 'oddaj'
	CurrentActionMsg  = ('Kliknij ~INPUT_CONTEXT~ aby ~o~oddać ~w~pojazd firmowy')
	CurrentActionData = {}

  elseif zone == 'magazyn' and onDuty == true and wypozyczyljuzpojazd == true and odebraljuzpaczke == false then
    Akt	  = 'maga'
	CurrentActionMsg  = ('Kliknij ~INPUT_CONTEXT~ aby ~g~odebrać ~w~paczki')
	CurrentActionData = {}

  end

  if otrzymalkoordynatydomu == true and GetDistanceBetweenCoords(coords, domx, domy, domz, true) < 1.5 and onDuty == true then
	Akt	  = 'wet435'
	CurrentActionMsg  = ('Kliknij ~INPUT_CONTEXT~ aby ~g~dostarczyć ~w~paczkę')
	CurrentActionData = {}
	end
end)
--
AddEventHandler('wojtek_kurier:pozamarkerem', function (zone)
  Akt = nil
end)
--
RegisterNetEvent('wojtek_kurier:rozpocznijprace')
AddEventHandler('wojtek_kurier:rozpocznijprace', function()

	if wypozyczyljuzpojazd == false then

		wypozyczyljuzpojazd = true
	TriggerEvent("pNotify:SendNotification",{
		text = ('Wypożyczasz pojazd firmowy'),
		type = "success",
		timeout = (2000),
		layout = "bottomCenter",
		queue = "kurier",
		animation = {
		open = "gta_effects_fade_in",
		close = "gta_effects_fade_out"
	}})

	local poj = Config.pojazd


	if onDuty == true then
		RequestModel(GetHashKey(poj))
		while not HasModelLoaded(GetHashKey(poj)) do
		Citizen.Wait(0)
	end

	ClearAreaOfVehicles(78.85, 96.78, 77.7, 5.0, false, false, false, false, false) 				
	local pojkurier = CreateVehicle(GetHashKey(poj), 78.85, 96.78, 77.7, -2.436,  996.786, 25.1887, true, true)
		SetEntityHeading(pojkurier, 72.3)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), pojkurier, - 1)
	end

 namagzyngo()


elseif manotewarning == false then
	manotewarning = true
	TriggerEvent("pNotify:SendNotification",{
		text = ('Wypożyczyłeś już pojazd'),
		type = "warning",
		timeout = (2000),
		layout = "bottomCenter",
		queue = "kurier",
		animation = {
		open = "gta_effects_fade_in",
		close = "gta_effects_fade_out"
	}})
	Wait(5000)
	manotewarning = false
end
end)
--
-- #### Funkcje #### --
--
function MenuPrzebieralnia()
	ESX.UI.Menu.CloseAll()
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'cloakroom',
	  {
		title    = 'Szatnia',
		align    = 'center',
		elements = {
		  {label = 'Ubranie robocze', value = 'job_wear'},
		  {label = 'Ubranie cywilne', value = 'citizen_wear'}
		}
	  },
	  function(data, menu)
		if data.current.value == 'citizen_wear' then
  
			  TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
			  Wait(Config.Czasprzebierania * 1000 + 250)
			  ClearPedTasks(GetPlayerPed(-1))
		  onDuty = false
		  majuznoty = false
  
		   TriggerServerEvent('wojtek_kurier:pow2')
		  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			  TriggerEvent('skinchanger:loadSkin', skin)
		  end)
		end
		if data.current.value == 'job_wear' then
  
			  TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
			  Wait(Config.Czasprzebierania * 1000 + 250)
			  ClearPedTasks(GetPlayerPed(-1))
		  onDuty = true
		  majuznoty = false
  
			TriggerServerEvent('wojtek_kurier:pow')
		  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			  if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)   
			else
				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
			end
			
		  end)
		end
		menu.close()
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  end
--
function Usunpojazdy()
	ped = GetPlayerPed(-1)
	pojazdusun = GetVehiclePedIsIn(ped, false)
    ESX.Game.DeleteVehicle(pojazdusun)
	wypozyczyljuzpojazd = false


	RemoveBlip(blipmagazyn)
end
--
function namagzyngo()

	magazynx = -1233.5
	magazyny = -2393.88

	SetNewWaypoint(magazynx, magazyny)


	blipmagazyn = AddBlipForCoord(magazynx, magazyny, 0)
    SetBlipSprite (blipmagazyn, 1)
    SetBlipDisplay(blipmagazyn, 4)
    SetBlipScale  (blipmagazyn, 0.7)
    SetBlipColour (blipmagazyn, 5)
    SetBlipAsShortRange(blipmagazyn, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Praca kuriera: Odbieranie paczek z magazynu')
	EndTextCommandSetBlipName(blipmagazyn)
end
--
function wylosujdom()

	RemoveBlip(blipdomu)
	local wylosowanydom = math.random(1,15)

	if wylosowanydom == 1 then
		domx = -51.90
	    domy = -398.21
		domz = 37.2
		elseif wylosowanydom == 2 then 
		domx = -876.35
		domy = 306.10
		domz = 83.2
		elseif wylosowanydom == 3 then
		domx = -848.69
		domy = 508.60
		domz = 89.9
		elseif wylosowanydom == 4 then
		domx = -884.16
		domy = 518.03
		domz = 91.5
		elseif wylosowanydom == 5 then
		domx = -873.33
		domy = 562.80
		domz = 95.7
		elseif wylosowanydom == 6 then 
		domx = -172.73
		domy = 238.96
		domz = 92.2
		elseif wylosowanydom == 7 then 
		domx = 798.60
		domy = -158.66
		domz = 73.93
 		elseif wylosowanydom == 8 then 
		domx = 773.94
		domy = -149.82
		domz = 74.7
		elseif wylosowanydom == 9 then 
		domx = 1262.65
		domy = -429.63
		domz = 69.1
		elseif wylosowanydom == 10 then 
		domx = 1266.63
		domy = -457.96
		domz = 69.7
		elseif wylosowanydom == 11 then 
		domx = 1265.48
		domy = -648.54
		domz = 67.1
		elseif wylosowanydom == 12 then 
		domx = 996.94
		domy = -729.46
		domz = 56.9
		elseif wylosowanydom == 13 then 
		domx = 295.90
		domy = -2093.40
		domz = 16.8
		elseif wylosowanydom == 14 then 
		domx = 236.21
		domy = -2046.23
		domz = 17.4
	elseif wylosowanydom == 15 then 
		domx = 192.24
		domy = -1883.28
		domz = 24.2
	end	

	SetNewWaypoint(domx, domy)

	blipdomu = AddBlipForCoord(domx, domy, 0)
    SetBlipSprite (blipdomu, 1)
    SetBlipDisplay(blipdomu, 4)
    SetBlipScale  (blipdomu, 0.7)
    SetBlipColour (blipdomu, 5)
    SetBlipAsShortRange(blipdomu, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Praca kuriera: dostarcz paczkę do domu')
	EndTextCommandSetBlipName(blipdomu)

	otrzymalkoordynatydomu = true

end
--
function powiadom()
	local notka = false
	if notka == false then
		otrzymalkoordynatydomu = false
	TriggerEvent("pNotify:SendNotification",{
		text = "<h3><center>Praca kuriera</center></h3>" .. "</br>Dostarczyłeś wszystkie przesyłki! Jedź do magazynu po nowe!",
		type = "success",
		timeout = (5000),
		layout = "bottomCenter",
		queue = "kurier",
		animation = {
		open = "gta_effects_fade_in",
		close = "gta_effects_fade_out"
	}})
	notka = true
	Wait(1500)
	notka = false
end
end
--
function odebralpaczkezmagazynuniebomusiszsobietakdorabiacboniemasznormalnejpracylmao()
	if odebraljuzpaczke == false then
	RemoveBlip(blipmagazyn)
	odebraljuzpaczke = true

	 iloscpaczek = math.random(4,8)

	TriggerEvent("pNotify:SendNotification",{
		text = "<h3><center>Praca kuriera</center></h3> </br>Odbierasz: <b style='color:#166927'>" .. iloscpaczek .. "</b> paczek, uważaj żeby ich nie uszkodzić i dostarcz je do kilentów!",
		type = "success",
		timeout = (2000),
		layout = "bottomCenter",
		queue = "kurier",
		animation = {
		open = "gta_effects_fade_in",
		close = "gta_effects_fade_out"
	}})

	wylosujdom()
end
end
--
function utratapaczki()
	local ogr = false
	if ogr == false then
		ogr = true
	if iloscpaczek > 0 then
		iloscpaczek = iloscpaczek - 1
		uszkodzonepaczki = uszkodzonepaczki + 1
		TriggerEvent("pNotify:SendNotification",{
			text = "<b style='color:#f30800'>Uszkodziłeś paczkę! Jedź ostrożniej!</b>",
			type = "warning",
			timeout = (5000),
			layout = "bottomCenter",
			queue = "kurier",
			animation = {
			open = "gta_effects_fade_in",
			close = "gta_effects_fade_out"
		}})
	Wait(500)
	ogr = false
	end
	end
end
--
function odswiezblipy() 

	if PlayerData.job ~= nil and PlayerData.job.name == 'kurier' then
	
	 blipypracy = AddBlipForCoord(82.58, 80.96, 78.0)
		SetBlipSprite (blipypracy, Config.rodzaj)
		SetBlipDisplay(blipypracy, 4)
		SetBlipScale  (blipypracy, Config.wielkosc)
		SetBlipColour (blipypracy, Config.kolor)
		SetBlipAsShortRange(blipypracy, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.opis)
		EndTextCommandSetBlipName(blipypracy)
	else
	RemoveBlip(blipypracy)
	end
	end
--

--------------------------------------------
------ Napisane przez wojtek.cfg#0349 ------
----------------- ©  2019 ------------------
--------------------------------------------
