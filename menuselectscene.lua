local composer = require( "composer" )
local scene = composer.newScene()

local data = require( "data" )
local maps = require( "maps" )
local widget = require("widget")

function onTap( event )
	if "ended" == event.phase then
		data.levelname = event.target.id
		composer.gotoScene( "game" )
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
	local x = actW * 0.5
	local y = actH * 0.25
	local num = 1
	for i = 1, #maps do
		local btn = widget.newButton({
			id = maps[i],
			label = "level " .. tostring( num ),
			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 0.5 } },
			textOnly = true,
			width = 240,
			height = 70,
			font = "font.ttf",
			fontSize = 70,
			x = x,
			y = y,
			onEvent = onTap
		})
		sceneGroup:insert( btn )
		y = y + actH * 0.1
		num = num + 1
	end
	
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