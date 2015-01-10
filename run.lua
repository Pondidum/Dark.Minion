local addon, ns = ...

ns.features.each(function(feature)
	local instance = feature:new()
	instance:enable()
end)
