
require( "imageinfo" )

local hud = { }
local hud_mt = { __index = hud }

function hud.new( numstars, size )
	local _newHUD = {}
	_newHUD.heartsCounter = 3
	_newHUD.maxStars = numstars
	_newHUD.starsCounter = 0
	_newHUD.ceilsize = size
	return setmetatable( _newHUD, hud_mt )
end

function hud:init( view )
	local group = display.newGroup( )
	
	local back = display.newRect( display.actualContentWidth * 0.5, self.ceilsize * 0.5, display.actualContentWidth, self.ceilsize )
	
	local heartImage = display.newImageRect( imagebytype.heart.filename, self.ceilsize, self.ceilsize )
	heartImage.x, heartImage.y = self.ceilsize, self.ceilsize * 0.5
	self.textAboutHeart = display.newText( tostring( self.heartsCounter ), self.ceilsize * 2, self.ceilsize * 0.5, "font.ttf", self.ceilsize * 0.9 )
	self.textAboutHeart:setFillColor( 0 )
	
	local starImage = display.newImageRect( imagebytype.star.filename, self.ceilsize, self.ceilsize )
	starImage.y = self.ceilsize * 0.5
	self.textAboutStars = display.newText( "00/00", 0, self.ceilsize * 0.5, "font.ttf", self.ceilsize * 0.9 )
	self.textAboutStars.x = display.actualContentWidth - self.textAboutStars.width * 0.5
	starImage.x = self.textAboutStars.x - ( self.textAboutStars.width * 0.5 + self.ceilsize * 0.5 )
	self.textAboutStars.text = "0/" .. tostring( self.maxStars )
	self.textAboutStars:setFillColor( 0 )
	
	group:insert( back )
	group:insert( heartImage )
	group:insert( self.textAboutHeart )
	group:insert( starImage )
	group:insert( self.textAboutStars )
	
	view:insert( group )
end

function hud:isAvailableFinish( )
	return self.starsCounter == self.maxStars
end

function hud:isLosing( )
	return self.heartsCounter == 0 and self.heartsCounter ~= self.maxHearts
end

function hud:catchStar( )
	self.starsCounter = self.starsCounter + 1
	self.textAboutStars.text = tostring( self.starsCounter ) .. "/" .. tostring( self.maxStars )
end

function hud:catchHeart( )
	self.heartsCounter = self.heartsCounter + 1
	self.textAboutHeart.text = tostring( self.heartsCounter )
	return true
end

function hud:hit( )
	self.heartsCounter = self.heartsCounter - 1
	self.textAboutHeart.text = tostring( self.heartsCounter )
end

function hud:removeSelf( )
	self.textAboutHeart:removeSelf( )
	self.textAboutStars:removeSelf( )
end

return hud