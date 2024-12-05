local loader = game:GetService("ReplicatedStorage"):WaitForChild("ProjectExample"):WaitForChild("loader")
local require = require(loader).bootstrapIn(loader.Parent)
