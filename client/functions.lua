function HandleCam(coords)
    -- Fade in screen quickly
    DoScreenFadeIn(500)
    Citizen.Wait(200)
    
    -- Instantly create and activate camera at high position (no animation to get there)
    startcam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
    SetCamCoord(startcam, coords.x, coords.y, coords.z + 800)  -- High above spawn
    PointCamAtCoord(startcam, coords.x, coords.y, coords.z)  -- Look down at spawn
    SetCamActive(startcam, true)
    RenderScriptCams(true, true, 0, true, true)  -- Instant activation, no fade
    
    -- Brief pause at high position
    Citizen.Wait(800)
    
    -- Zoom down quickly (faster transition)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
    SetCamCoord(cam, coords.x, coords.y, coords.z + 100)  -- Mid-height
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    SetCamActiveWithInterp(cam, startcam, 2500, 1, 1)  -- Reduced from 5000 to 2500
    Citizen.Wait(2500)
    
    -- Quick close-up view
    cam2 = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
    SetCamCoord(cam2, coords.x + 3, coords.y + 3, coords.z + 1.5)  -- Close view
    PointCamAtCoord(cam2, coords.x, coords.y, coords.z)
    SetCamActiveWithInterp(cam2, cam, 1500, 1, 1)  -- Reduced from 3000 to 1500
    Citizen.Wait(1500)
    
    -- Transition to player view quickly
    local finalCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
    SetCamCoord(finalCam, coords.x, coords.y, coords.z + 1.5)  -- Player eye level
    local headingRad = math.rad(coords.h)
    local lookX = coords.x + math.cos(headingRad) * 10
    local lookY = coords.y + math.sin(headingRad) * 10
    PointCamAtCoord(finalCam, lookX, lookY, coords.z)
    SetCamActiveWithInterp(finalCam, cam2, 1000, 1, 1)  -- Reduced from 2000 to 1000
    Citizen.Wait(1000)
    
    -- Play sounds
    PlaySoundFrontend(-1, 'Zoom_In', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    PlaySoundFrontend(-1, 'CAR_BIKE_WHOOSH', 'MP_LOBBY_SOUNDS', 1)
    
    -- Quick fade out
    RenderScriptCams(false, true, 500, true, true)  -- Reduced from 1000 to 500
    Citizen.Wait(500)
    
    -- Clean up cameras
    if DoesCamExist(startcam) then
        DestroyCam(startcam, false)
    end
    if DoesCamExist(cam) then
        DestroyCam(cam, false)
    end
    if DoesCamExist(cam2) then
        DestroyCam(cam2, false)
    end
    if DoesCamExist(finalCam) then
        DestroyCam(finalCam, false)
    end
    
    -- Ensure script cameras are fully disabled
    RenderScriptCams(false, false, 0, true, true)
end

RegisterNetEvent('crow_spawnselect:ToggleNUIFocus')
AddEventHandler('crow_spawnselect:ToggleNUIFocus', function()
    NUI_status = true
    while NUI_status do
        SetNuiFocus(NUI_status, NUI_status)
        Wait(500)
    end
    SetNuiFocus(false, false)
end)

function round(num)
    local mult = math.pow(10, 2)
    return math.floor(num * mult + 0.5) / 100
end

