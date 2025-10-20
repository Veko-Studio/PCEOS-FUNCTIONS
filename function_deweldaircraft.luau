if not _G.deweldblock then
  loadstring(game:HttpGet("https://github.com/Veko-Studio/PCEOS-FUNCTIONS/blob/main/function_deweldblock.luau"))()
end
repeat task.wait() until _G.deweldblock
function _G.deweldaircraft()
	local ac = workspace:FindFirstChild(game.Players.LocalPlayer.Name.." Aircraft")
	for i=1,#ac:GetChildren() do
		task.spawn(function()	
			for i2=1,#ac:GetChildren() do
				_G.deweldblock(ac:GetChildren()[i],ac:GetChildren()[i2])
			end
		end)
	end
end
--function _G.deweldaircraft()
