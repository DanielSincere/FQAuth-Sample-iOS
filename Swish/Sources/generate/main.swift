let config = try Config.load()

try writeAuthServerURL(config: config)
try writeRandomStringServerURL(config: config)
try generateProject(config: config)
