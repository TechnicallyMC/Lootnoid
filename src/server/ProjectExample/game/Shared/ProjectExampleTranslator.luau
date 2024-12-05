local require = require(script.Parent.loader).load(script)

return require("JSONTranslator").new("ProjectExampleTranslator", "en", {
	gameName = "ProjectExample",
})
