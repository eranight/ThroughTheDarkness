local aspectRatio = display.pixelHeight / display.pixelWidth
local _width = 720
local _height = 1280

application =
{

	content =
	{
		width = aspectRatio > 1.5 and _width or math.floor( _height / aspectRatio ),
		height = aspectRatio < 1.5 and _height or math.floor( _width * aspectRatio ), 
		scale = "letterBox",
		fps = 60,
		--[[width = 768,
		height = 1024, 
		scale = "letterBox"]]--
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
