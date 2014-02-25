local addon, ns = ...

ns.features.each(function(feature)
	feature.enable()
end)
