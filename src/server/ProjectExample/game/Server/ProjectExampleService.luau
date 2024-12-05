local require = require(script.Parent.loader).load(script)

local ProjectExampleService = {}
ProjectExampleService.ServiceName = "ProjectExampleService"

function ProjectExampleService:Initialize(serviceSet)
	print("Server: ProjectExampleService initialized!")
end

function ProjectExampleService:Start(serviceSet)
	print("Server: ProjectExampleService started!")
end

return ProjectExampleService
