local require = require(script.Parent.loader)

local CollectionService = game:GetService("CollectionService")

local Signal = require("Signal")
local Maid = require("Maid")

local Binder = {}
Binder.__index = Binder

function Binder.new(Tag, Constructor, ...)
	local self = setmetatable({}, Binder)
	self.Tag = Tag
	self.Constructor = Constructor
	self.Args = { ... }
	self.ClassAdded = Signal.new()
	self.ClassRemoved = Signal.new()
	self.maid = Maid.new()
	self.instances = {}
	self._started = false
	return self
end

function Binder:Init()
	CollectionService:GetInstanceAddedSignal(self.Tag):Connect(function(instance)
		if typeof(self.Constructor) == "function" then
			local args = self.Args or {}
			local newObject = self.Constructor(instance, unpack(args))
			self.instances[instance] = newObject
		end

		if typeof(self.Constructor) == "table" and self.Constructor.new then
			local newObject = self.Constructor.new(instance)
			self.instances[instance] = newObject
		end

		self.ClassAdded:Fire(instance)
	end)

	CollectionService:GetInstanceRemovedSignal(self.Tag):Connect(function(instance)
		local obj = self.instances[instance]
		if obj and obj.Destroy then
			obj:Destroy()
		end

		if typeof(self.Constructor) == "table" and self.Constructor.Destroy then
			self.Constructor.Destroy(instance)
		end

		self.ClassRemoved:Fire(instance)
		self.instances[instance] = nil
	end)

	for _, object in pairs(CollectionService:GetTagged(self.Tag)) do
		if typeof(self.Constructor) == "function" then
			local args = self.Args or {}
			local newObject = self.Constructor(object, unpack(args))
			self.instances[object] = newObject
		end

		if typeof(self.Constructor) == "table" and self.Constructor.new then
			local newObject = self.Constructor.new(object)
			self.instances[object] = newObject
		end
	end
end

function Binder:Start()
	if self._started then
		return
	end
	self._started = true
	self:Init()
end

function Binder:GetTag()
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	return self.Tag
end

function Binder:GetConstructor()
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	return self.Constructor
end

function Binder:GetClassAddedSignal()
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	return self.ClassAdded
end

function Binder:GetClassRemovedSignal()
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	return self.ClassRemoved
end

function Binder:GetAll()
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	local result = {}
	for _, object in pairs(game:GetService("CollectionService"):GetTagged(self.Tag)) do
		result[object] = self.Constructor
	end
	return result
end

function Binder:Tag(instance: Instance)
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	CollectionService:AddTag(instance, self.Tag)
end

function Binder:HasTag(instance: Instance)
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	return CollectionService:HasTag(instance, self.Tag)
end

function Binder:Untag(instance: Instance)
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	CollectionService:RemoveTag(instance, self.Tag)
end

function Binder:Destroy()
	if not self._started then
		warn("[Binder] Binder", self, "is not started, call :Start() on it!")
	end
	for instance, object in pairs(self.instances) do
		if object.Destroy then
			object:Destroy()
		end
	end

	self.maid:GiveTask(self)
	self.maid:DoCleaning()
end

return Binder
