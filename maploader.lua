local map = { }
local map_mt = { __index = map }

local json = require( "json" )
local physics = require( "physics" )
require( "imageinfo" )

function map.new( jsonstring )
	local _newMap = json.decode( jsonstring )
	_newMap.finishgroup = {}
	_newMap.numstars  = 0
	_newMap.numhearts = 0
	if _newMap then
		_newMap.startPosition = { x = _newMap.startX, y = _newMap.startY }
		return setmetatable( _newMap, map_mt )
	else
		return nil
	end
end

function map:init( view )
	self.group = display.newGroup( )
	local scale = math.min( ( display.actualContentWidth - self.ceilsize ) / ( self.width * self.ceilsize ), ( display.actualContentHeight - self.ceilsize ) / ( self.height * self.ceilsize ) )
	self.ceilsize = self.ceilsize * scale
	local cell_offset = self.ceilsize - self.offset
	local offsetX = display.contentCenterX - self.width * cell_offset * 0.5
	local offsetY = display.contentCenterY - self.height * cell_offset * 0.5 + self.ceilsize * 0.5
	for i = 1, #self.groups do
		for j = 1, #self.groups[i].items do
			local _imageinfo = imagebytype[self.groups[i].items[j].itemType]
			local newItem = display.newImageRect( _imageinfo.filename, self.ceilsize, self.ceilsize )
			newItem.tag = self.groups[i].items[j].itemType
			if newItem.tag == "star" then
				self.numstars = self.numstars + 1
			elseif newItem.tag == "heart" then
				self.numhearts = self.numhearts + 1
			end
			newItem.x = self.groups[i].items[j].x * cell_offset + self.ceilsize * 0.5 + offsetX
			newItem.y = self.groups[i].items[j].y * cell_offset + self.ceilsize * 0.5 + offsetY
			if _imageinfo.bodytype == "shape" then
				local _shape = _imageinfo.getshape( scale )
				physics.addBody( newItem, "static", { shape = _shape } )
			else
				local _radius = _imageinfo.getradius( scale )
				physics.addBody( newItem, "static", { radius = _radius } )
			end
			newItem:rotate( self.groups[i].items[j].rotation )
			self.group:insert( newItem )
			if self.groups[i].number == -1 then
				table.insert( self.finishgroup, self.group.numChildren )
			end
		end
	end
	view:insert( self.group )
	local player = display.newImageRect( imagebytype.circle.filename, self.ceilsize, self.ceilsize )
	player.tag = "player"
	player.x = self.startX * cell_offset + self.ceilsize * 0.5 + offsetX
	player.y = self.startY * cell_offset + self.ceilsize * 0.5 + offsetY
	physics.addBody( player, "dynamic", { radius = imagebytype.circle.getradius( scale ) } )
	player.gravityScale = 0
	view:insert( player )
	return player
end

function map:getFinishGroupXY( )
	local t = {}
	for i = 1, #self.finishgroup do
		table.insert( t, { x = self.group[self.finishgroup[i]].x, y = self.group[self.finishgroup[i]].y })
	end
	return t
end

function map:destroingFinishGroup( )
	for i = 1, #self.finishgroup do
		self.group[self.finishgroup[i]].isVisible = false
		self.group[self.finishgroup[i]].y = self.group[self.finishgroup[i]].y - self.ceilsize * 0.5
		self.group[self.finishgroup[i]].tag = "finish"
	end
	table.remove( self.finishgroup )
end

function map:removeSelf( )

end

return map