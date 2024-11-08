require("session"):setup({
	sync_yanked = true,
})

function Status:name()
	local h = cx.active.current.hovered
	if not h then
		return ui.Span("")
	end
	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end

	return ui.Span(" " .. h.name .. linked)
end

-- Full border configuration for yazi on preview: https://github.com/yazi-rs/plugins/tree/main/full-border.yazi
require("full-border"):setup({})
