local function includes(tab, val)
  for index, value in ipairs(tab) do
      if value == val then
          return true
      end
  end

  return false
end -- Stackoverflow

function DisableControls()
  Citizen.CreateThread(function()
    while disable do
      Citizen.Wait(0)
      DisableControlAction(0, 69, true)
      DisableControlAction(0, 68, true)
      DisableControlAction(0, 24, true)
      DisableControlAction(0, 25, true)
    end;
  end);
end;

function checkSpeed()
  local playerPed = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(playerPed, false)
  local speed = GetEntitySpeed(vehicle)
  if Config.Settings.kmh then
    speed = math.ceil(speed * 3.6)
  else
    speed = math.ceil(speed * 2.236936)
  end
  print("Speed: " .. speed)
  if speed > Config.Settings.disallowSpeed then
    return true
  else
    return false
  end
end;

function checkVehicle()
  local playerPed = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(playerPed, false)
  local class = GetVehicleClass(vehicle)
  if includes(Config.DevSettings.disallowedClasses, class) == false then
    return false
  end
  if Config.Settings.disallowOnPassenger == false and GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
    return false
  end
  if Config.Settings.disallowOnPassenger == true and GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
    return true
  end
  if Config.Settings.disallowOnDriver and GetPedInVehicleSeat(vehicle, -1) == playerPed then
    return true
  end
  return false
end;

local disable = false
Citizen.CreateThread(function()
  local playerPed = PlayerPedId()
  while true do
    Citizen.Wait(500)
    if IsPedInAnyVehicle(playerPed, false) and checkSpeed() and checkVehicle() then
      if not disable then
        disable = true
        DisableControls()
      end
    else
      if disable then
        disable = false
      end
    end
  end;
end);