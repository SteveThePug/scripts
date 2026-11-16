-- cursor_follow: keep a floating window glued next to the mouse cursor (Hyprland Lua config)
-- Picture-in-Picture windows follow automatically; SUPER+P makes the focused window follow,
-- or pauses/resumes following; SUPER+SHIFT+P stops; SUPER+CTRL+P toggles a bigger window centered
-- above the cursor; SUPER+ALT+Space/Left/Right play/pause and seek the video (via playerctl);
-- SUPER+ALT+Up/Down widen/narrow the gap to the cursor; SUPER+ALT+P lists these keybindings.
-- SUPER+A opens a terminal beside the cursor to ask Claude a quick question (cursor_ask.sh); it holds
-- keyboard focus while following and stops following once the question is sent, so it can be scrolled.
-- Load from hyprland.lua with: require("cursor_follow")

local M = {
	cfg = {
		width = 480, -- size applied when a window starts following
		height = 270,
		gap = 24, -- px between the cursor hotspot and the window
		gap_step = 8, -- px added/removed per gap key press
		margin = 8, -- keep this far from monitor edges
		dir = { x = 1, y = -1 }, -- starting side of the cursor (right, above); flips at screen edges
		centered_scale = 1.25, -- window size multiplier while centered above the cursor
		interval = 8, -- ms between cursor polls
		player = "firefox", -- MPRIS player for the video keys (Waterfox shows up as firefox)
		seek = 10, -- seconds skipped by the seek keys
		ask_width = 640, -- size of the SUPER+A question window
		ask_height = 420,
	},
	target = nil, -- address of the followed window
	paused = false,
	centered = false, -- window centered horizontally above the cursor instead of beside it
}

local cfg = M.cfg
local last_x, last_y
-- current side of the cursor per axis; stays flipped until the window hits the opposite edge
local side = { x = cfg.dir.x, y = cfg.dir.y }
local timer
-- marks the followed window so it can be picked back up after a config reload
local tag = "cursor-follow"
-- marks it as centered too, so the mode survives a reload
local centered_tag = "cursor-follow-centered"
-- class of the SUPER+A question window; cursor_ask.sh retitles it to "cursor-ask: <question>"
local ask_class = "cursor-ask"
-- window that was following before the question window took over, picked back up when it closes
local resume_after_ask

local function selector()
	return "address:" .. M.target
end

local function is_ask(w)
	return w ~= nil and w.class == ask_class
end

-- a question has been sent from this window
local function asked(w)
	return w.title:sub(1, #ask_class + 2) == ask_class .. ": "
end

-- focus follows the mouse and the followed window is never under the cursor, so the question
-- window holds keyboard focus while it follows
local function lock_focus(on)
	local w = M.target and hl.get_window(selector())
	if is_ask(w) then
		hl.dispatch(hl.dsp.window.set_prop({ window = selector(), prop = "stay_focused", value = on and "1" or "0" }))
	end
end

local function set_tag(name, on)
	hl.dispatch(hl.dsp.window.tag({ window = selector(), tag = (on and "+" or "-") .. name }))
end

local function resize(x, y)
	hl.dispatch(hl.dsp.window.resize({ window = selector(), x = math.floor(x + 0.5), y = math.floor(y + 0.5) }))
end

-- centered mode always starts with the window above the cursor
local function reset_side()
	side.x, side.y = cfg.dir.x, M.centered and -1 or cfg.dir.y
end

-- Keep a window of `size` starting at `p` within [lo, hi] minus the margin
local function clamp(p, size, lo, hi)
	p = math.max(lo + cfg.margin, math.min(p, hi - cfg.margin - size))
	return math.floor(p + 0.5)
end

-- Position along one axis: on side `dir` of the cursor, flipped if it would leave the monitor
-- and the other side has room. Returns the position and the (possibly flipped) side.
local function axis(cur, size, lo, hi, dir)
	local after, before = cur + cfg.gap, cur - cfg.gap - size
	local fits_after, fits_before = after + size <= hi - cfg.margin, before >= lo + cfg.margin
	if dir > 0 and not fits_after and fits_before then
		dir = -1
	elseif dir < 0 and not fits_before and fits_after then
		dir = 1
	end
	return clamp(dir > 0 and after or before, size, lo, hi), dir
end

function M.detach()
	timer:set_enabled(false)
	if M.target then
		set_tag(tag, false)
		set_tag(centered_tag, false)
		lock_focus(false)
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
	local x, y
	if M.centered then
		x = clamp(c.x - w.size.x / 2, w.size.x, m.x, m.x + mw)
	else
		x, side.x = axis(c.x, w.size.x, m.x, m.x + mw, side.x)
	end
	y, side.y = axis(c.y, w.size.y, m.y, m.y + mh, side.y)
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
	reset_side()
	local sel = selector()
	set_tag(tag, true)
	set_tag(centered_tag, M.centered)
	hl.dispatch(hl.dsp.window.float({ window = sel, action = "enable" }))
	hl.dispatch(hl.dsp.window.pin({ window = sel, action = "enable" }))
	-- moves would otherwise animate and trail behind the cursor
	hl.dispatch(hl.dsp.window.set_prop({ window = sel, prop = "no_anim", value = "1" }))
	if not keep_size then
		local s = M.centered and cfg.centered_scale or 1
		resize(cfg.width * s, cfg.height * s)
	end
	lock_focus(true)
	timer:set_enabled(true)
end

function M.toggle_pause()
	M.paused = not M.paused
	last_x, last_y = nil, nil
	timer:set_enabled(not M.paused)
	lock_focus(not M.paused)
end

function M.change_gap(d)
	cfg.gap = math.max(0, cfg.gap + d)
end

function M.toggle_centered()
	M.centered = not M.centered
	reset_side()
	local w = M.target and hl.get_window(selector())
	if w then
		set_tag(centered_tag, M.centered)
		local s = M.centered and cfg.centered_scale or 1 / cfg.centered_scale
		resize(w.size.x * s, w.size.y * s)
	end
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

hl.window_rule({
	name = "cursor-follow-ask",
	match = { class = "^(" .. ask_class .. ")$" },
	float = true,
	pin = true,
	size = cfg.ask_width .. " " .. cfg.ask_height,
	no_anim = true,
})

----------------
---- EVENTS ----
----------------

local function maybe_attach_pip(w)
	if w.title == pip_title and w.address ~= M.target then
		M.attach(w)
	end
end

local function maybe_attach_ask(w)
	if is_ask(w) and w.address ~= M.target then
		resume_after_ask = M.target
		M.attach(w, true)
	end
end

hl.on("window.open", maybe_attach_pip)
hl.on("window.open", maybe_attach_ask)
-- browsers can set the PiP title after the window maps
hl.on("window.title", maybe_attach_pip)

-- stop following once a question is sent, so the answer can be scrolled with the mouse
hl.on("window.title", function(w)
	if w.address == M.target and is_ask(w) and asked(w) and not M.paused then
		M.toggle_pause()
	end
end)

hl.on("window.close", function(w)
	if w.address == M.target then
		M.detach()
		-- hand following back to the window the question window took over from
		local prev = is_ask(w) and resume_after_ask and hl.get_window("address:" .. resume_after_ask)
		if prev and prev.floating then
			M.attach(prev, true)
		end
	end
end)

------------------
---- KEYBINDS ----
------------------

local keys -- { keys, description, action, bind options }, listed by M.help

local function player(args)
	return hl.dsp.exec_cmd("playerctl -p " .. cfg.player .. " " .. args)
end

function M.help()
	local lines = {}
	for _, k in ipairs(keys) do
		lines[#lines + 1] = k[1] .. ": " .. k[2]
	end
	hl.exec_cmd("notify-send -t 10000 'cursor follow' '" .. table.concat(lines, "\n") .. "'")
end

function M.toggle_ask()
	for _, w in ipairs(hl.get_windows()) do
		if is_ask(w) then
			hl.dispatch(hl.dsp.window.close({ window = "address:" .. w.address }))
			return
		end
	end
	hl.exec_cmd(
		"kitty --class "
			.. ask_class
			.. " -o confirm_os_window_close=0 -o window_padding_width=10 -o 'map escape close_window' -e "
			.. os.getenv("HOME")
			.. "/.config/hypr/cursor_ask.sh"
	)
end

keys = {
	{
		"SUPER + P",
		"follow the focused window, or pause/resume",
		function()
			if M.target then
				M.toggle_pause()
			else
				local w = hl.get_active_window()
				if w then
					M.attach(w)
				end
			end
		end,
	},
	{ "SUPER + SHIFT + P", "stop following", M.detach },
	{ "SUPER + CTRL + P", "toggle a bigger window centered above the cursor", M.toggle_centered },
	{ "SUPER + ALT + space", "play/pause the video", player("play-pause") },
	{ "SUPER + ALT + left", "skip back " .. cfg.seek .. "s", player("position " .. cfg.seek .. "-"), { repeating = true } },
	{ "SUPER + ALT + right", "skip forward " .. cfg.seek .. "s", player("position " .. cfg.seek .. "+"), { repeating = true } },
	{
		"SUPER + ALT + up",
		"widen the gap to the cursor",
		function()
			M.change_gap(cfg.gap_step)
		end,
		{ repeating = true },
	},
	{
		"SUPER + ALT + down",
		"narrow the gap to the cursor",
		function()
			M.change_gap(-cfg.gap_step)
		end,
		{ repeating = true },
	},
	{ "SUPER + ALT + P", "show these keybindings", M.help },
	{ "SUPER + A", "ask Claude a quick question, or close the question window", M.toggle_ask },
}

for _, k in ipairs(keys) do
	hl.bind(k[1], k[3], k[4])
end

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
	M.centered = hl.get_windows({ tag = centered_tag })[1] ~= nil
	M.attach(resumed, true)
	if is_ask(resumed) and asked(resumed) then
		M.toggle_pause()
	end
end

return M
