require("hs.ipc") -- lets /Applications/Hammerspoon.app/Contents/Frameworks/hs/hs query this config

local HERDR_APP = "dev.herdr.app"

-- Quick-terminal-style summon/dismiss of Herdr. The app is bound to all
-- Spaces in flake.nix, so it shows up on the current Space instead of
-- switching to its own.
hs.hotkey.bind({ "ctrl" }, "`", function()
	local app = hs.application.get(HERDR_APP)
	if app == nil or #app:allWindows() == 0 then
		hs.application.launchOrFocusByBundleID(HERDR_APP)
	elseif app:isFrontmost() then
		app:hide()
	else
		app:activate(true)
	end
end)

-- Pinch over Herdr -> herdr pane zoom (or any keystrokes)

local DEBUG = false -- log every pinch event to the Hammerspoon console

local HERDR = os.getenv("HOME") .. "/.local/bin/herdr-app"
local HERDR_VIEW = os.getenv("HOME") .. "/.config/herdr-app/view.json"
local THRESHOLD = 0.15 -- accumulated magnification needed to fire
local KEY_GAP = 0.04 -- seconds between strokes in a chord

local running = {} -- keep tasks referenced until they exit, or GC may reap them

local function herdr(...)
	local args = { ... }
	return function()
		local task
		task = hs.task.new(HERDR, function(code, _, err)
			running[task] = nil
			if code ~= 0 then
				print("herdr " .. table.concat(args, " ") .. " failed: " .. err)
			end
		end, args)
		running[task] = true
		task:start()
	end
end

-- strokes: list of {mods, key} sent in sequence (a chord)
local function keys(strokes)
	return function()
		for i, stroke in ipairs(strokes) do
			hs.timer.doAfter((i - 1) * KEY_GAP, function()
				hs.eventtap.keyStroke(stroke[1], stroke[2], 0)
			end)
		end
	end
end

-- Herdr's pane.zoom only toggles, so read whether the shown tab is zoomed
-- (view.json: tabs[<shown tab>].zoomed, a pane id or null) and toggle only
-- when it isn't already the way the pinch asks for.
local toggleZoom = herdr("do", "pane.zoom")
local function paneZoom(on)
	return function()
		local ok, view = pcall(hs.json.read, HERDR_VIEW)
		local tab = ok and view and view.spaces and view.spaces[view.active]
		local t = tab and view.tabs and view.tabs[tab]
		local zoomed = t ~= nil and type(t.zoomed) == "string"
		if zoomed ~= on then
			toggleZoom()
		end
	end
end

-- once: fire a single time per gesture; otherwise fire every THRESHOLD step
local actions = {
	pinchOut = { once = true, run = paneZoom(true) }, -- show only the focused pane
	pinchIn = { once = true, run = paneZoom(false) }, -- show all panes again
	-- e.g. font size: { once = false, run = keys({ { { "cmd" }, "=" } }) }
}

-- Check the app under the pointer rather than the frontmost one, so a pinch
-- over a background Herdr window still zooms it.
local function herdrUnderPointer()
	local p = hs.mouse.absolutePosition()
	local el = hs.axuielement.systemWideElement():elementAtPosition(p.x, p.y)
	local app = el and hs.application.applicationForPID(el:pid())
	return app ~= nil and app:bundleID() == HERDR_APP
end

local acc, fired, overHerdr = 0, false, nil
local reset = hs.timer.delayed.new(0.25, function()
	acc, fired, overHerdr = 0, false, nil
end)

local T = hs.eventtap.event.types
pinchTap = hs.eventtap.new({ T.gesture, T.magnify }, function(e)
	local details = e:getTouchDetails() or {}
	local m = details.magnification
	if not m then
		return false -- scroll/rotate/other touches pass through
	end

	-- look up the pointer's app once per gesture, not on every event
	if overHerdr == nil then
		overHerdr = herdrUnderPointer()
	end
	if DEBUG then
		print(string.format("pinch magnification=%.4f acc=%.4f herdr=%s", m, acc, tostring(overHerdr)))
	end
	reset:start()
	if not overHerdr then
		return false
	end

	if not fired then
		acc = acc + m
		if math.abs(acc) >= THRESHOLD then
			local action = acc > 0 and actions.pinchOut or actions.pinchIn
			action.run()
			if action.once then
				fired = true
			else
				acc = 0
			end
		end
	end
	return true -- swallow the pinch so Herdr never sees it
end):start()

-- macOS disables event taps that stall; turn it back on if that happens
pinchWatchdog = hs.timer.doEvery(5, function()
	if not pinchTap:isEnabled() then
		pinchTap:start()
	end
end)
