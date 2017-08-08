local runtime = 0
local divs = 1000 / 60 

function getDT( )
	local tmp = system.getTimer( )
	local dt = ( tmp - runtime ) / divs
	runtime = tmp
	return dt
end