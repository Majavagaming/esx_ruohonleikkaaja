function GetGroundHash(veh)
	local coords = GetEntityCoords(veh)
	local num = StartShapeTestCapsule(coords.x,coords.y,coords.z+4,coords.x,coords.y,coords.z-2.0, 1,1,veh,7)
	local arg1, arg2, arg3, arg4, arg5 = GetShapeTestResultEx(num)
	return arg5
end


local x = -1161.9
local y = 28.391
local z = 50.45
local raha = 0
local abusenesto = 0
local keikalla = false
local ruohonleikkurissa = false
local ax = -1352.767
local ay = 125.881
local az = 56.239
local ah = 8.602
local auto = nil

Citizen.CreateThread(function()
	while true do
		local pelaaja = GetPlayerPed(-1)
		local koortinaatit = GetEntityCoords(pelaaja)
		if(GetDistanceBetweenCoords(koortinaatit, x, y, z, true) < 300) then
			if(GetDistanceBetweenCoords(koortinaatit, ax, ay, az, true) < 3) then
				if not keikalla then
					HelpNotification('Paina ~INPUT_PICKUP~ aloittaaksesi hommat')
					if IsControlJustPressed(0, 38) then
						spawnaaauto()
						keikalla = true
						for i=1, 1000 do
							DrawText3Ds(koortinaatit.x, koortinaatit.y, koortinaatit.z+1, 'Ajele nurmikkoo ja tuu takas kun haluut rahaa')
							Citizen.Wait(5)
						end
					end
				else
					HelpNotification('Paina ~INPUT_PICKUP~ palauttaaksesi auton ja lopettaksesi hommat')
					if IsControlJustPressed(0, 38) then
						if ruohonleikkurissa then
							DeleteEntity(auto)
							if raha > 100 then
								raha = raha / 100
								TriggerServerEvent('ruohonleikkuri:maksu', raha)
								for i=1, 1000 do
									DrawText3Ds(koortinaatit.x, koortinaatit.y, koortinaatit.z+1, 'Hyvää duunia tienasit ~g~'..raha..' €')
									Citizen.Wait(5)
								end
								raha = 0
							else
								for i=1, 1000 do
									DrawText3Ds(koortinaatit.x, koortinaatit.y, koortinaatit.z+1, 'Oot laiskotellu et saa penniäkään')
									Citizen.Wait(5)
								end
								raha = 0
							end
						else
							for i=1, 1000 do
								DrawText3Ds(koortinaatit.x, koortinaatit.y, koortinaatit.z+1, 'Palauta ens kerralla ruohonleikkuri saatanan jullikka')
								Citizen.Wait(5)
							end
						end
						keikalla = false
					end
				end
			end
			if IsPedInAnyVehicle(pelaaja, false) then
				auto = GetVehiclePedIsIn(pelaaja, false)
				local autonmalli = GetEntityModel(auto)
				local autonnimi = GetDisplayNameFromVehicleModel(autonmalli)
				if autonnimi == "MOWER" then
					ruohonleikkurissa = true
					local coords = GetEntityCoords(auto)
					local num = StartShapeTestCapsule(coords.x,coords.y,coords.z+4,coords.x,coords.y,coords.z-2.0, 1,1,auto,7)
					local arg1, arg2, arg3, arg4, arg5 = GetShapeTestResultEx(num)
					if arg5 ~= 282940568 then
						if GetEntitySpeed(auto) > 10/3.6 then
							raha = raha + 1
							if IsControlPressed(0, 34) or IsControlPressed(0, 35) then
								abusenesto = abusenesto + 1
								if abusenesto > 5000 then
									raha = 0
									abusenesto = 0
								end
							else
								abusenesto = 0
							end
						end
					else
						if keikalla then
							DrawText3Ds(koortinaatit.x, koortinaatit.y, koortinaatit.z, 'Emme maksa asfaltilla ajelemisesta!')
						end
					end
				else
					ruohonleikkurissa = false
				end
			else
				ruohonleikkurissa = false
			end
			if keikalla then
				DrawMarker(25, ax, ay, az-1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, nil, nil, false)
			end
		else
			Citizen.Wait(1000)
		end
		Citizen.Wait(5)
	end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
	SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.018, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function HelpNotification(msg)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, false, true, -1)
end

function spawnaaauto()
	local model = "mower"
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
	
	local yolo = CreateVehicle(model, ax, ay, az, ah, true, false)
	TaskWarpPedIntoVehicle(GetPlayerPed(-1),  yolo, -1)
end