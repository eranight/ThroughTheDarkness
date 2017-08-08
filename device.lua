local M = {}

M.isApple = false
M.isAndroid = false
M.is_iPad = false
M.isSimulator = false

local model = system.getInfo("model")

if "simulator" == system.getInfo("environment") then
    M.isSimulator = true
end

M.isTall = false
if (display.pixelHeight/display.pixelWidth) > 1.5 then
    M.isTall = true
end

if string.sub(model,1,2) == "iP" then 
     M.isApple = true

     if string.sub(model, 1, 4) == "iPad" then
         M.is_iPad = true
     end
else
    M.isAndroid = true
end

return M