local loader = script.Parent.Parent.ProjectExample["imported_modules"]["@lootlua"].loader
local require = require(loader).bootstrapIn(script.Parent.Parent.ProjectExample)

local ServiceSet = require("ServiceSet")

local serviceSet = ServiceSet.new()
serviceSet:Init()
serviceSet:Start()
