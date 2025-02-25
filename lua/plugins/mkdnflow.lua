local okay, mkdnflow = pcall(require, 'mkdnflow')

if okay then
	mkdnflow.setup({
		links = {
			transform_explicit = function(text)
				text = text:gsub(" ", "-")
				text = text:lower()
				text = 'notes/' .. text
				return(text)
			end
		},
		new_file_template = {
			use_template = true,
			template = [[
---
tags:
---
# {title}
]]
		}
	})
end
