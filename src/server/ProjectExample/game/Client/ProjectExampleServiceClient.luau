local require = require(script.Parent.loader).load(script)

local ProjectExampleServiceClient = {}
ProjectExampleServiceClient.ServiceName = "ProjectExampleServiceClient"

function ProjectExampleServiceClient:Initialize(serviceSet)
	print("Client: ProjectExampleServiceClient initialized!")
end

function ProjectExampleServiceClient:Start(serviceSet)
	print("Client: ProjectExampleServiceClient started!")
end

return ProjectExampleService
