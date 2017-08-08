local layer = {}
local layer_mt = { __index = layer }

local actW = display.actualContentWidth
local actH = display.actualContentHeight

function layer.new( size )
	local _newLayer = {}
	_newLayer.radius = size * 3.5
	return setmetatable( _newLayer, layer_mt ) 
end

function layer:init( view, x, y )
	local group = display.newGroup( )
	
	self.darklayer = display.newRect( actW * 0.5, actH * 0.5, actW, actH )
	self.darklayer:setFillColor( 0 )
	self.darklayer.isFocus = false
	local mask = graphics.newMask( "image/circlemask.png" )
	self.darklayer:setMask( mask )
	self.darklayer.isHitTestMasked = false
	self.halo = display.newImage( "image/halo.png", actW * 0.5, actH * 0.5 )
	self.halo.isVisible = false
	self:setPosition( x, y )
	group:insert( self.darklayer )
	group:insert( self.halo )
	
	view:insert( group )
end

function layer:onWarning( )
	self.halo.x, self.halo.y = self:getPosition( )
	self.halo.isVisible = true
end

function layer:offWarning( )
	self.halo.isVisible = false
end

function layer:setPosition( x, y )
	self.darklayer.isFocus = false
	self.darklayer.maskX = x - actW * 0.5
	self.darklayer.maskY = y - actH * 0.5
end

function layer:getPosition( )
	return self.darklayer.maskX + actW * 0.5, self.darklayer.maskY + actH * 0.5
end

function onTouch( event )
	local t = event.target
	if event.phase == 'began' then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		t.x0 = event.x - t.maskX
		t.y0 = event.y - t.maskY
	elseif t.isFocus then
		if event.phase == 'moved' then
			local maskX = event.x - t.x0
			local maskY = event.y - t.y0
			t.maskX, t.maskY = maskX, maskY
		elseif event.phase == 'ended' or "cancelled" == event.phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end
	return true
end

function layer:onTouchable( )
	self.darklayer:addEventListener( "touch", onTouch )
end

function layer:offTouchable( )
	self.darklayer:removeEventListener( "touch", onTouch )
end

function layer:removeSelf( )
	self.darklayer:removeSelf( )
	self.halo:removeSelf( )
end

return layer