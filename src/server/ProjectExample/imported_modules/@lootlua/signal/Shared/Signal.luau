local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		Bindable = Instance.new("BindableEvent"),
	}, Signal)
end

function Signal:Connect(callback)
	return self.Bindable.Event:Connect(callback)
end

function Signal:ConnectParallel(callback)
	return self.Bindable.Event:ConnectParallel(callback)
end

function Signal:Fire(...)
	self.Bindable:Fire(...)
end

function Signal:Destroy()
	self.Bindable:Destroy()
	self = nil
end

return Signal
