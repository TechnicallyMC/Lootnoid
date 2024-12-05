local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Maid = require(script.Maid)

local Loader = {}
Loader.__index = Loader
Loader.ClassName = "Loader"

function Loader.new(packages)
	local self = setmetatable({}, Loader)

	self._maid = Maid.new()

	self._packages = packages

	return self
end

function Loader.bootstrapIn(packages)
	local self = Loader.new(packages)

	if RunService:IsStudio() and RunService:IsServer() then
		packages.Parent = ReplicatedStorage

		for _, folder in packages:GetDescendants() do
			if not folder.Parent:FindFirstChild("loader") then
				local link = script.LoaderLink:Clone()
				link.Parent = folder
				link.Name = "loader"
				continue
			end
		end

		if packages:FindFirstChild("imported_modules"):FindFirstChild("@lootlua"):FindFirstChild("loader") then
			packages["imported_modules"]["@lootlua"].loader.Parent = packages
		end
	elseif RunService:IsServer() then
		self:_populateClient()

		for _, folder in pairs(packages:GetDescendants()) do
			if folder.Name:lower() == "client" then
				folder:Destroy()
			end
		end
	end

	return self
end

function Loader.load(packages)
	return Loader.new(packages)
end

function Loader:__index(request)
	if Loader[request] then
		return Loader[request]
	else
		self:_findPackage(request)
	end
end

function Loader:__call(request)
	if typeof(request) == "string" then
		local module = self:_findPackage(request)
		return require(module)
	else
		return require(request)
	end
end

function Loader:_findPackage(request)
	for _, package in pairs(self._packages:GetDescendants()) do
		if package.Name == request then
			return package
		end
	end
end

function Loader:_populateClient()
	local clone = self._packages:Clone()
	clone.Name = self._packages.Name

	for _, folder in pairs(clone:GetDescendants()) do
		if folder:IsA("Folder") and not folder.Parent:FindFirstChild("loader") then
			local link = script.LoaderLink:Clone()
			link.Parent = folder
			link.Name = "loader"
			continue
		end

		if folder.Name:lower() == "server" then
			folder:Destroy()
		end
	end

	if
		clone:FindFirstChild("imported_modules") and clone:FindFirstChild("imported_modules"):FindFirstChild("@lootlua")
	then
		clone["imported_modules"]["@lootlua"].loader.Parent = clone
	end

	clone.Parent = ReplicatedStorage
end

return Loader
