local composer = require( "composer" )
local scene = composer.newScene( )

local widget = require( "widget" )

local function handleButtonEvent( event )
    if "ended" == event.phase then
		composer.removeScene( "startmenu" )
        composer.gotoScene( "startmenu", { effect = "fade", time = 500 } )
    end
    return true
end

function scene:create( event )

    local sceneGroup = self.view
	
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
	background:setFillColor( 0 )
	sceneGroup:insert( background )
	
	local startButton = widget.newButton( {
		id = "button1",
        label = "Back",
		font = native.systemFont,
		textOnly = true,
		labelColor = { default = { 1 }, over = { 1 } },
		fontSize = display.actualContentHeight * 0.1,
        width = display.actualContentWidth * 0.5,
        height = display.actualContentHeight * 0.1,
        onEvent = handleButtonEvent
	} )
	startButton.x = display.contentCenterX
	startButton.y = display.contentCenterY
	sceneGroup:insert( startButton )

end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
    
    elseif phase == "did" then
	
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
	
    elseif phase == "did" then
	
    end
end

function scene:destroy( event )

    local sceneGroup = self.view
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene