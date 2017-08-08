local composer = require( "composer" )
local device = require( "device" )
local utility = require( "utility" )
local globalData = require( "globaldata" )

globalData.levels = utility.loadTable( "levels.json" )

local function onKeyEvent( event )

    local phase = event.phase
    local keyName = event.keyName
    print( event.phase, event.keyName )

    if ( "back" == keyName and phase == "up" ) then
        if ( composer.getCurrentSceneName() == "startmenu" ) then
            native.requestExit()
        else
            composer.gotoScene( "startmenu", { effect = "crossFade", time = 500 } )
        end
        return true
    end
    return false
end

if device.isAndroid then
    Runtime:addEventListener( "key", onKeyEvent )
end

local function systemEvents(event)
    if event.type == "applicationSuspend" then
	
    elseif event.type == "applicationResume" then
	
    elseif event.type == "applicationExit" then
	
    elseif event.type == "applicationStart" then
        composer.gotoScene( "startmenu", { time = 250, effect = "fade" } )
    end
    return true
end
Runtime:addEventListener("system", systemEvents)