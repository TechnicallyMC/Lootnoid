local Find = {}

function Find.path(parent: Instance, path: string)
	local pathSplit = string.split(path, "/")

	local instance = parent
	for _, part in pathSplit do
		local child = instance:FindFirstChild(part)
		if child == nil then
			error(`failed to find {part} in {instance:GetFullName()} (full path: {path}`, 2)
		end
		instance = child
	end

	return instance
end

return Find
