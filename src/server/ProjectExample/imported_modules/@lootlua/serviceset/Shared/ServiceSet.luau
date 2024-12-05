local require = require(script.Parent:WaitForChild("loader")).load(script.Parent.Parent.Parent)

local BaseObject = require("BaseObject")
local Signal = require("Signal")

local ServiceSet = setmetatable({}, BaseObject)
ServiceSet.ClassName = "ServiceSet"
ServiceSet.__index = ServiceSet

function ServiceSet.new(provider)
	local self = BaseObject.new()
	setmetatable(self, ServiceSet)

	self._services = {}
	self._provider = provider
	self._servicesToInitializeNext = {}
	self._initializedServices = {}
	self._servicesToStartNext = {}
	self._startedServices = {}
	self._destroyingSignal = Signal.new()

	return self
end

function ServiceSet:GetService(service)
	if typeof(service) == "Instance" then
		service = require(service)
	end

	if typeof(service) ~= "table" then
		error(("ServiceSet:GetService expects service to be a table or Instance, got %q"):format(typeof(service)), 2)
	end

	if self._services[service] then
		self:_init(self._services[service])
		return self._services[service]
	else
		self:_addService(service)
		self:_init(service)
		return service
	end
end

function ServiceSet:Init()
	while next(self._servicesToInitializeNext) do
		local service = next(self._servicesToInitializeNext)
		self._servicesToInitializeNext[service] = nil
		self:_init(service)
	end
end

function ServiceSet:Start()
	while next(self._servicesToStartNext) do
		local service = next(self._servicesToStartNext)
		self._servicesToStartNext[service] = nil
		self:_start(service)
	end
end

function ServiceSet:_addService(service)
	assert(self._services[service] == nil, "Service already exists")
	assert(type(service.Init) == "function", "Service must have an Init method")
	assert(type(service.Start) == "function", "Service must have a Start method")

	self._services[service] = service
	self._servicesToInitializeNext[service] = true
end

function ServiceSet:_init(service)
	if self._initializedServices[service] then
		return
	end
	service:Initialize(self)
	if service.Start then
		task.defer(function()
			service:Start(self)
		end)
	end
	self._initializedServices[service] = true
end

function ServiceSet:_start(service)
	if self._startedServices[service] then
		return
	end
	service:Start(self)
	self._startedServices[service] = true
end

return ServiceSet
