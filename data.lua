local M = {}
	M.levelname = ""
	function M.getDataFromFile( filename )
		local path = system.pathForFile( filename, system.DocumentDirectory )
		if path then
			local f = io.open( path, "r" )
			if f then
				local jsonstring = f:read( "*a" )
				io.close(f)
				return jsonstring
			end
		end
		return nil
	end
return M