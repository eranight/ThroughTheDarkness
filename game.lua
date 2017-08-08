local composer = require( "composer" )
local scene = composer.newScene()

local data = require( "data" )
local physics = require( "physics" )
local mapping = require( "maploader" )
local huding = require( "hudloader" )
local laying = require( "layerloader" )

local map
local hud
local layer
local player
local myText
local signsText
local startX, startY
local isReachFinish = false
local isOutLine = false
local isNotExist = false
local isLock = false
local speed = 90

local actW = display.actualContentWidth
local actH = display.actualContentHeight

function coll( event )
	if event.phase == "began" then
		local obj1, obj2
		if event.object1.tag == "player" then
			obj1 = event.object1
			obj2 = event.object2
		elseif event.object2.tag == "player" then
			obj1 = event.object2
			obj2 = event.object1
		end
		if obj1 and obj2 then
			if obj2.tag == "finish" then
				isReachFinish = true
			elseif obj2.tag == "star" then
				obj2:removeSelf( )
				hud:catchStar( )
			elseif obj2.tag == "heart" then
				obj2:removeSelf( )
				hud:catchHeart( )
			elseif obj2.tag == "triangle" then
				isNotExist = true
			end
		end
	end
end

function gameLoop( )
	if hud:isAvailableFinish( ) then
		map:destroingFinishGroup( )
		local xx, yy = layer:getPosition( )
		local dist = math.sqrt( ( signsText.x - xx ) ^ 2 + ( signsText.y - yy ) ^ 2 )
		if dist < layer.radius then
			signsText.isVisible = false
		else
			signsText.isVisible = true
		end
	end
	if not isLock then
		local xx, yy = layer:getPosition( )
		local dist = math.sqrt( ( player.x - xx ) ^ 2 + ( player.y - yy ) ^ 2 )
		if dist > 1 then 
			_x = ( xx - player.x ) / dist * speed
			_y = ( yy - player.y ) / dist * speed
			player:setLinearVelocity( _x, _y )
		else
			player:setLinearVelocity( 0, 0 )
		end
		if dist > layer.radius then isOutLine = true
		elseif dist > layer.radius * 0.8 then
			layer:onWarning( )
		elseif dist < layer.radius * 0.8 then
			layer:offWarning( )
		end
	end
	if isNotExist or isOutLine then
		hud:hit( )
		isNotExist = false
		isOutLine = false
		player:setLinearVelocity( 0, 0 )
		layer:offTouchable( )
		layer:onWarning( )
		if hud:isLosing( ) then
			player:setLinearVelocity( 0, 0 )
			Runtime:removeEventListener( "enterFrame", gameLoop )
			myText.text = "You Lose"
			myText.isVisible = true
		else
			isLock = true
			timer.performWithDelay( 500,
			function()
				isLock = false
				player.x, player.y = startX, startY
				layer:setPosition( startX, startY )
				layer:onTouchable( )
				layer:offWarning( )
			end )
		end
	end
	if isReachFinish then
		player:setLinearVelocity( 0, 0 )
		layer:offTouchable( )
		Runtime:removeEventListener( "enterFrame", gameLoop )
		myText.text = "You Win"
		myText.isVisible = true
	end
end

function scene:create( event )
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene )
	end
	local sceneGroup = self.view
	
	display.setDefault( "background", 0.99 )
	
	physics.start( )
	physics.pause( )
	local ln = data.getDataFromFile( data.levelname )
	map = mapping.new( ln )
	player = map:init( sceneGroup )
	startX = player.x
	startY = player.y
	
	layer = laying.new( map.ceilsize )
	layer:init( sceneGroup, player.x, player.y )
	
	hud = huding.new( map.numstars, map.ceilsize )
	hud:init( sceneGroup )
	
	local xy = map:getFinishGroupXY( )
	x, y = 0, 0
	for i = 1, #xy do
		x = x + xy[i].x
		y = y + xy[i].y
	end
	
	signsText = display.newText( "! ! !", x / #xy, y / #xy, "font.ttf", map.ceilsize )
	signsText:setFillColor( 255, 255, 0 )
	signsText.isVisible = false
	sceneGroup:insert( signsText )
	
	myText = display.newText( "", actW * 0.5, actH * 0.5, "font.ttf", map.ceilsize )
	myText:setFillColor( 1, 0, 0 )
	myText.isVisible = false
	sceneGroup:insert( myText )
end

function scene:show( event )
	if event.phase == "did" then
		physics.start( )
		layer:onTouchable( )
		Runtime:addEventListener( "collision", coll )
		Runtime:addEventListener( "enterFrame", gameLoop )
	end
end

function scene:hide( event )
	if event.phase == "will" then
		layer:offTouchable( )
		Runtime:removeEventListener( "collision", coll )
		Runtime:removeEventListener( "enterFrame", gameLoop )
	end
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene