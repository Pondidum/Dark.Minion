local addon, ns = ...

ns.features.each(function(feature)
	feature.initialise()
	feature.enable()
end)
