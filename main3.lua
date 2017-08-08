-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require( "physics" )
local mapping = require( "maploader" )
local huding = require( "hudloader" )

physics.start( )

local map

local path = system.pathForFile( "testmap.json", system.DocumentDirectory )
local f = io.open( path, "r" )
if f then
	local jsonstring = f:read( "*a" )
	map = mapping.new( jsonstring )
	io.close(f)
	f = nil
else
	exit( 1 )
end

local cir

local view = display.newGroup( )

local startX
local startY
if map then
	cir = map:init( view )
	startX, startY = cir.x, cir.y
end
local hud = huding.new( map.numstars, map.ceilsize )

local actW = display.actualContentWidth
local actH = display.actualContentHeight
local spsize = map.ceilsize
local countW = math.floor( actW / spsize )
local countH = math.floor( actH / spsize )

print( actW )
print( actH )

display.setDefault( "background", 0.99 )

local image = display.newImage( "image/front.png", cir.x, cir.y )
local halo = display.newImage( "image/halo.png", actW * 0.5, actH * 0.5 )
halo.isVisible = false
view:insert( image )
view:insert( halo )
hud:init( view )

local isAvailableFinish = false
local isReachFinish = false
local isFocused = false
local isOutLine = false
local isNotExist = false
local speed = 90

local function coll( event )
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

function onTouch( event )
	if event.phase == 'began' then
		isFocused = true
		x0, y0 = event.x - image.x, event.y - image.y 
	elseif isFocused then
		if event.phase == 'moved' then
			if event.x - x0 < image.x and image.x > spsize * 0.5 then
				image.x = event.x - x0
			elseif event.x - x0 > image.x and image.x < actW - spsize * 0.5 then
				image.x = event.x - x0
			end
			if event.y - y0 < image.y and image.y > spsize * 0.5 then
				image.y = event.y - y0
			elseif event.y - y0 > image.y and image.y < actH - spsize * 0.5 then
				image.y = event.y - y0
			end
			halo.x, halo.y = image.x, image.y
		elseif event.phase == 'ended' then
			isFocused = false
		end
	end
end

function gameLoop( )
	if hud:isAvailableFinish( ) then
		map:destroingFinishGroup( )
	end
	if isNotExist or isOutLine then
		hud:hit( )
		cir.x, cir.y = startX, startY
		image.x, image.y = startX, startY
		halo.x, halo.y =  actW * 0.5, actH * 0.5
		halo.isVisible = false
		isNotExist = false
		isFocused = false
		isOutLine = false
	end
	local dist = math.sqrt( ( cir.x - image.x ) ^ 2 + ( cir.y - image.y ) ^ 2 )
	if dist > 1 then 
		_x = ( image.x - cir.x ) / dist * speed
		_y = ( image.y - cir.y ) / dist * speed
		cir:setLinearVelocity( _x, _y )
	else
		cir:setLinearVelocity( 0, 0 )
	end
	if dist > 160 then isOutLine = true
	elseif dist > 130 then
		halo.isVisible = true
	elseif dist < 130 then
		halo.isVisible = false
	end
	if hud:isLosing( ) then
		cir:setLinearVelocity( 0, 0 )
		transition.cancel( cir )
		image:removeEventListener( "touch", onTouch )
		Runtime:removeEventListener( "enterFrame", gameLoop )
		local myText = display.newText( "You Lose", actW * 0.5, actH * 0.5, native.systemFont )
		myText:setFillColor( 1, 0, 0 )
	end
	if isReachFinish then
		cir:setLinearVelocity( 0, 0 )
		transition.cancel( cir )
		image:removeEventListener( "touch", onTouch )
		Runtime:removeEventListener( "enterFrame", gameLoop )
		local myText = display.newText( "You Win", actW * 0.5, actH * 0.5, native.systemFont )
		myText:setFillColor( 1, 0, 0 )
	end
end

image:addEventListener( "touch", onTouch )
Runtime:addEventListener( "collision", coll )
Runtime:addEventListener( "enterFrame", gameLoop )