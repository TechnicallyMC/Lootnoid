local BaseObject = {}
BaseObject.__index = BaseObject

local require = require(script.Parent:WaitForChild("loader")).load(script.Parent.Parent.Parent)
local Maid = require("Maid")

function BaseObject.new(obj)
	return setmetatable({
		_maid = Maid.new(),
		_obj = obj,
	}, BaseObject)
end

function BaseObject:Destroy()
	self._maid:DoCleaning()
	setmetatable(self, nil)
end

return BaseObject
