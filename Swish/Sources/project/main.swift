let config = try Config.load()

try writeAuthServerURL(config: config)
try generateProject(config: config)
