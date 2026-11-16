-- cursor_follow: keep a floating window glued next to the mouse cursor (Hyprland Lua config)
-- Picture-in-Picture windows follow automatically; SUPER+P makes the focused window follow,
-- or pauses/resumes following; SUPER+SHIFT+P stops.
-- Load from hyprland.lua with: require("cursor_follow")

local M = {
	cfg = {
		width = 480, -- size applied when a window starts following
		height = 270,
		gap = 24, -- px between the cursor hotspot and the window
		margin = 8, -- keep this far from monitor edges
		dir = { x = 1, y = -1 }, -- preferred side of the cursor (right, above); flips at screen edges
		interval = 8, -- ms between cursor polls
	},
	target = nil, -- address of the followed window
	paused = false,
}

local cfg = M.cfg
local last_x, last_y
local timer
-- marks the followed window so it can be picked back up after a config reload
local tag = "cursor-follow"

local function selector()
	return "address:" .. M.target
end

-- Position along one axis: on side `dir` of the cursor, flipped if it would leave the monitor
local function axis(cur, size, lo, hi, dir)
	local after, before = cur + cfg.gap, cur - cfg.gap - size
	local p = dir > 0 and after or before
	if dir > 0 and after + size > hi - cfg.margin then
		p = before
	elseif dir < 0 and before < lo + cfg.margin then
		p = after
	end
	p = math.max(lo + cfg.margin, math.min(p, hi - cfg.margin - size))
	return math.floor(p + 0.5)
end

function M.detach()
	timer:set_enabled(false)
	if M.target then
		hl.dispatch(hl.dsp.window.tag({ window = selector(), tag = "-" .. tag }))
	end
	M.target, M.paused = nil, false
	last_x, last_y = nil, nil
end

local function place()
	local w = M.target and hl.get_window(selector())
	-- stop once the window is closed or tiled again
	if not w or not w.floating then
		M.detach()
		return
	end
	local c, m = hl.get_cursor_pos(), hl.get_monitor_at_cursor()
	if not c or not m then
		return
	end

	local mw, mh = m.width / m.scale, m.height / m.scale
	local x = axis(c.x, w.size.x, m.x, m.x + mw, cfg.dir.x)
	local y = axis(c.y, w.size.y, m.y, m.y + mh, cfg.dir.y)
	if x == last_x and y == last_y then
		return
	end
	last_x, last_y = x, y
	hl.dispatch(hl.dsp.window.move({ window = selector(), x = x, y = y }))
end

timer = hl.timer(place, { timeout = cfg.interval, type = "repeat" })
timer:set_enabled(false)

-- keep_size: picking a window back up after a reload, so leave its size alone
function M.attach(w, keep_size)
	if M.target then
		M.detach()
	end
	M.target = w.address
	local sel = selector()
	hl.dispatch(hl.dsp.window.tag({ window = sel, tag = "+" .. tag }))
	hl.dispatch(hl.dsp.window.float({ window = sel, action = "enable" }))
	hl.dispatch(hl.dsp.window.pin({ window = sel, action = "enable" }))
	-- moves would otherwise animate and trail behind the cursor
	hl.dispatch(hl.dsp.window.set_prop({ window = sel, prop = "no_anim", value = "1" }))
	if not keep_size then
		hl.dispatch(hl.dsp.window.resize({ window = sel, x = cfg.width, y = cfg.height }))
	end
	timer:set_enabled(true)
end

function M.toggle_pause()
	M.paused = not M.paused
	last_x, last_y = nil, nil
	timer:set_enabled(not M.paused)
end

---------------
---- RULES ----
---------------

local pip_title = "Picture-in-Picture"

hl.window_rule({
	name = "cursor-follow-pip",
	match = { title = "^(" .. pip_title .. ")$" },
	float = true,
	pin = true,
	size = cfg.width .. " " .. cfg.height,
	no_anim = true,
	no_initial_focus = true,
	keep_aspect_ratio = true,
})

----------------
---- EVENTS ----
----------------

local function maybe_attach_pip(w)
	if w.title == pip_title and w.address ~= M.target then
		M.attach(w)
	end
end

hl.on("window.open", maybe_attach_pip)
-- browsers can set the PiP title after the window maps
hl.on("window.title", maybe_attach_pip)

hl.on("window.close", function(w)
	if w.address == M.target then
		M.detach()
	end
end)

------------------
---- KEYBINDS ----
------------------

hl.bind("SUPER + P", function()
	if M.target then
		M.toggle_pause()
	else
		local w = hl.get_active_window()
		if w then
			M.attach(w)
		end
	end
end)

hl.bind("SUPER + SHIFT + P", M.detach)

-- A config reload starts this module from scratch while the followed window stays pinned,
-- so it would tag along across workspaces but stand still. Pick it back up.
local resumed = hl.get_windows({ tag = tag })[1]
if not resumed then
	for _, w in ipairs(hl.get_windows()) do
		if w.title == pip_title then
			resumed = w
			break
		end
	end
end
if resumed then
	M.attach(resumed, true)
end

return M
