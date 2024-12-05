local Maid = {}
Maid.__index = Maid

function Maid.new()
	local self = setmetatable({}, Maid)
	self._tasks = {}
	self.autoClean = false
	return self
end

function Maid:GiveTask(_task)
	if not _task then
		return
	end
	table.insert(self._tasks, _task)
	if _task.Destroy then
		table.insert(self._tasks, _task)
		_task.Destroying:Connect(function()
			self:DoCleaning(_task)
		end)
	elseif typeof(_task) == "function" then
		table.insert(self._tasks, _task)
	end
end

function Maid:DoCleaning(_task)
	for i, v in ipairs(self._tasks) do
		if v == _task then
			table.remove(self._tasks, i)
			if typeof(v) == "function" then
				v()
			end
			return
		end
	end
end

function Maid:Clean()
	for _, _task in ipairs(self._tasks) do
		if typeof(_task) == "function" then
			_task()
		end
	end
	self._tasks = {}
end

function Maid:CleanAll()
	for _, _task in ipairs(self._tasks) do
		if typeof(_task) == "function" then
			_task()
		end
	end
	self._tasks = {}
end

function Maid:MarkAutoClean(enabled)
	self.autoClean = enabled
end

return Maid
