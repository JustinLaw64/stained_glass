-- Justin's Stained-Glass Mod

local ModName = minetest.get_current_modname()
local modpath = (minetest.get_modpath(ModName))

local ColorOverrides = {
	grey = "#7F7F7F",
	dark_grey = "#3F3F3F",
	dark_green = "#007F00",
	green = "#00FF00",
	brown = "#8E4A00",
	violet = "#5E08A7",
}

-- Register every color mentioned.
for i, item in ipairs(dye.dyes) do
	local color = item[1]
	if (ColorOverrides[color] ~= "x") then
		-- Names
		local ColorName = item[2]
		local ColorValue = (ColorOverrides[color] or color)
		local GlassBlockName = (ModName..":" .. color .. "_glass")
		local GlassPaneName = (ModName.."_pane_" .. color)
		-- Glass textures
		local TransparentStain = "((stained_glass_white.png^[colorize:"..ColorValue..")^[mask:stained_glass_transparent.png)"
		local GlassTexture = "(default_glass.png^[colorize:"..ColorValue..")"
		local GlassTexture_Stained = (TransparentStain.."^"..GlassTexture)
		local GlassDetailTexture = (TransparentStain.."^(default_glass_detail.png^[colorize:"..ColorValue..")")
	
		minetest.register_node(GlassBlockName, {
			description = ColorName .. " Glass",
			drawtype = "glasslike_framed_optional",
			tiles = {GlassTexture_Stained, GlassDetailTexture},
			use_texture_alpha = true,
			paramtype = "light",
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {cracky = 3, oddly_breakable_by_hand = 3, [ModName.."_glass"] = 1},
			sounds = default.node_sound_glass_defaults(),
		})
		xpanes.register_pane(GlassPaneName, {
			description = ColorName .. " Glass Pane",
			textures = {GlassTexture_Stained, "xpanes_pane_half.png", "xpanes_white.png"},
			use_texture_alpha = true,
			inventory_image = GlassTexture,
			wield_image = GlassTexture,
			sounds = default.node_sound_glass_defaults(),
			groups = {snappy=2, cracky=3, oddly_breakable_by_hand=3, pane=1, [ModName.."_pane"] = 1},
			recipe = {
				{GlassBlockName, GlassBlockName, GlassBlockName},
				{GlassBlockName, GlassBlockName, GlassBlockName}
			}
		})
		
		minetest.register_craft({
			output = GlassBlockName.." 8",
			recipe = {
				{"default:glass", "default:glass", "default:glass"},
				{"default:glass", "dye:" .. color, "default:glass"},
				{"default:glass", "default:glass", "default:glass"},
			}
		})
		minetest.register_craft({
			output = "xpanes:"..GlassPaneName.."_flat 8",
			recipe = {
				{"xpanes:pane_flat", "xpanes:pane_flat", "xpanes:pane_flat"},
				{"xpanes:pane_flat", "dye:" .. color, "xpanes:pane_flat"},
				{"xpanes:pane_flat", "xpanes:pane_flat", "xpanes:pane_flat"},
			}
		})
	end
end

minetest.register_craft({
	output = "default:glass",
	type = "cooking",
	recipe = "group:"..ModName.."_glass"
})
minetest.register_craft({
	output = "xpanes:pane_flat",
	type = "cooking",
	recipe = "group:"..ModName.."_pane",
	cooktime = 2
})
