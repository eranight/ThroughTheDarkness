local composer = require( "composer" )

local function onKeyEvent( event )

    local phase = event.phase
    local keyName = event.keyName
    if ( "back" == keyName and phase == "up" ) then
        if ( composer.getCurrentSceneName() == "menu" ) then
            native.requestExit()
        elseif composer.getCurrentSceneName() == "game" then
            composer.gotoScene( "menuselectscene" )
		else
			composer.gotoScene( "menu" )
        end
        return true
    end
    return false
end
Runtime:addEventListener( "key", onKeyEvent )

local function systemEvents(event)
    if event.type == "applicationStart" then
        composer.gotoScene( "menu" )
    end
    return true
end
Runtime:addEventListener("system", systemEvents)