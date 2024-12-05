local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loader = game:GetService("ReplicatedStorage"):WaitForChild("ProjectExample"):WaitForChild("loader")
local require = require(loader).bootstrapIn(loader.Parent)

local ServiceSet = require("ServiceSet")

local serviceSet = ServiceSet.new()

serviceSet:Init()
serviceSet:Start()
