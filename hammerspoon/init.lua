-- A global variable for the Hyper Mode
-- note that F17 isn't actually bound to anything
k = hs.hotkey.modal.new({}, "F17")

function leftHalf()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function leftThird()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 3
  f.h = max.h
  win:setFrame(f)
end

function leftTwoThirds()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w * 2 / 3 
  f.h = max.h
  win:setFrame(f)
end

function rightHalf()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function rightThird()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w * 2 / 3)
  f.y = max.y
  f.w = max.w / 3
  f.h = max.h
  win:setFrame(f)
end

function rightTwoThirds()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 3)
  f.y = max.y
  f.w = max.w * 2 / 3
  f.h = max.h
  win:setFrame(f)
end


function fullScreen()
  local win = hs.window.focusedWindow()
  win:maximize()
  -- local f = win:frame()
  -- local screen = win:screen()
  -- local max = screen:frame()
  -- f.x = max.x
  -- f.y = max.y
  -- f.w = max.w
  -- f.h = max.h
  -- win:setFrame(f)
end

function throwRight()
  local next_screen = hs.screen.allScreens()[2]
  local win = hs.window.focusedWindow()
  win:moveToScreen(next_screen)
  leftHalf()
end

function throwLeft()
  -- local cur_screen = hs.screen.mainScreen()
  -- local prev_screen = cur_screen:previous()
  local prev_screen = hs.screen.allScreens()[1]
  local win = hs.window.focusedWindow()
  win:moveToScreen(prev_screen)
  rightHalf()
end

singleapps = {
  {'m', 'Microsoft Teams'},
  {'o', 'Microsoft Outlook'},
  -- {'z', 'Papers 3.4.7'},
  {'v', 'Neovim'},
  -- {'e', 'Evernote'},
  {'t', 'iTerm2'},
  -- {'s', 'Slack'},
  -- {'n', 'Marked 2'},
  {'l', 'Calendar'},
  {'d', 'Google Play Music Desktop Player'},
  -- {'d', 'iTunes'},
  {'p', 'Microsoft PowerPoint'},
  {'q', 'Preview'},
  {'c', 'Google Chrome'},
  {'e', 'Microsoft Edge'},
  {'n', 'Microsoft OneNote'},
  -- {'i', 'Dash'},
  -- {'x', 'Xcode'},
  -- {'w', 'Twitter'},
  -- {'j', 'IntelliJ IDEA'},
}

focus = function(appname)
  -- hs.application.launchOrFocus(appname)
  local running_app = hs.application.get(appname)
  -- hs.alert(running_app:name())
  if running_app ~= nil then
    -- hs.alert("aafdsfds")
    -- local win = running_app:mainWindow()
    -- win:focus()
    running_app:activate()
  end
  k.triggered = true
end

for i, app in ipairs(singleapps) do
  -- k:bind({}, app[1], "pressed", function() launch(app[2]); k:exit(); end, nil, nil)
  k:bind({}, app[1], function() focus(app[2]); end)
end

movements = {
  {'-', leftHalf},
  {'=', rightHalf},
  {'9', leftTwoThirds},
  {'0', rightTwoThirds},
  {'7', leftThird},
  {'8', rightThird},
  {'=', rightHalf},
  {'f', fullScreen},
  {"'", throwRight},
  {";", throwLeft},
}

for i,bnd in ipairs(movements) do
  k:bind({}, bnd[1], function() bnd[2](); k.triggered = true; end)
end

-- k:bind({}, '-', leftHalf)
-- k:bind({}, '=', rightHalf)
-- k:bind({}, '9', leftTwoThirds)
-- k:bind({}, '0', rightTwoThirds)
-- k:bind({}, '7', leftThird)
-- k:bind({}, '8', rightThird)
-- k:bind({}, '=', rightHalf)
-- k:bind({}, 'f', fullScreen)
-- k:bind({}, "'", throwRight)
-- k:bind({}, ";", throwLeft)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedHyper = function()
  k.triggered = false
  -- hs.alert("Hyper mode entered")
  k:enter()
end

-- -- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- --   send ESCAPE if no other keys are pressed.
releasedHyper = function()
  -- hs.alert("Hyper mode exited")
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedHyper, releasedHyper)

hs.hotkey.bind({"cmd", "shift"}, 'l', hs.caffeinate.startScreensaver)

hs.window.animationDuration = 0 -- disable animations



-----------------------------------------------
-- Hyper i to show window hints
-----------------------------------------------

-- k:bind({}, 'i', function() hs.hints.windowHints(); k:exit() end)
-- hs.hotkey.bind({'cmd', 'shift'}, 'i', hs.hints.windowHints)

-- hs.hotkey.bind(hyper, "i", function()
--     hs.hints.windowHints()
-- end)

-- -----------------------------------------------
-- -- Hyper hjkl to switch window focus
-- -----------------------------------------------
--
-- hs.hotkey.bind(hyper, 'k', function()
--     hs.window.focusedWindow():focusWindowNorth()
-- end)
--
-- hs.hotkey.bind(hyper, 'j', function()
--     hs.window.focusedWindow():focusWindowSouth()
-- end)
--
-- hs.hotkey.bind(hyper, 'l', function()
--     hs.window.focusedWindow():focusWindowEast()
-- end)
--
-- hs.hotkey.bind(hyper, 'h', function()
--     hs.window.focusedWindow():focusWindowWest()
-- end)

-------------------------------------------

-- Defeat paste-blocking
hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)


-------------------------------------------------
-- FOR DEBUGGING: prints out every key tap event
-- tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
--   print(hs.inspect(event:getRawEventData()))
-- end)
-- tap:start()
-------------------------------------------------

-------------------------------------------
-- Reload config on writes
-------------------------------------------


function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

hs.hotkey.bind({'ctrl', 'shift'}, '1', hs.reload)


local myWatcher1 = hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles/hammerspoon/", reloadConfig):start()
local myWatcher2 = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

function lock()
  hs.caffeinate.startScreensaver()
  -- hs.caffeinate.lockScreen()
end

hs.hotkey.bind({"cmd", "shift"}, 'l', lock)

hs.alert.show("Config loaded")

