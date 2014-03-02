local addon, ns = ...

local core = Dark.core
local options = core.options

local optionsBuilder = {

	new = function()

		local this = {}
		local sections = {}

		this.addSection = function(name, sectionUi)
			sections[name] = sectionUi
		end

		this.build = function()

			local composite = {}
			-- main ui

			for name, config in pairs(sections) do

				local container = {
					name = "sectons",
					type = "Frame",

					children = config,

				}

				table.insert(composite, container)

			end

			options.register("Minion", {
				description = "A little helper.",
				children = composite,
			})

		end

		return this

	end,

}

ns.options = optionsBuilder
