local composer = require( "composer" )
local scene = composer.newScene()

local data = require( "data" )
local widget = require("widget")

local function closeFunc()
	if system.getInfo("platformName")=="Android" then
        native.requestExit()
    else
        os.exit() 
    end
end

function scene:create( event )
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene )
	end
	display.setDefault( "background", 0)
	local actW = display.actualContentWidth
	local actH = display.actualContentHeight
	local sceneGroup = self.view
	
	local playBtn = widget.newButton
	{
		label = "Play",
		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 0.5 } },
		textOnly = true,
		width = 240,
		height = 120,
		font = "font.ttf",
		fontSize = 120,
		x = actW * 0.5,
		y = actH * 0.4,
		onEvent = function ( event )
					if "ended" == event.phase then
						composer.gotoScene( "menuselectscene" )
					end
				  end
	}
	
	local exitBtn = widget.newButton
	{
		label = "Exit",
		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 0.5 } },
		textOnly = true,
		font = "font.ttf",
		fontSize = 120,
		fontSize = 120,
		width = 240,
		height = 120,
		x = actW * 0.5,
		y = actH * 0.5 + actH * 0.1,
		onEvent = function ( event )
					if "ended" == event.phase then
						if system.getInfo("platformName")=="Android" then
							native.requestExit()
						else
							os.exit() 
						end
					end
				  end
	}
	
	sceneGroup:insert( playBtn )
	sceneGroup:insert( exitBtn )
end

function scene:show( event )
	if event.phase == "did" then
	
	end
end

function scene:hide( event )
	if event.phase == "will" then
	
	end
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene