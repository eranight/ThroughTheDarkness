local lvl_ceil = { }
local lvl_ceil_mt = { __index = lvl_ceil }

function lvl_ceil.createLevelCeil( view, number, starcnt, mapname, posx, posy, w, h )
	local _newCeil = { }
	_newCeil.mapname = mapname
	
	return setmetatable( _newCeil, lvl_ceil_mt )
end

return lvl_ceil