-- A global variable for the Hyper Mode
-- note that F17 isn't actually bound to anything
k = hs.hotkey.modal.new({}, "F17")

singleapps = {
  {'m', 'Mailplane 3'},
  {'z', 'Papers 3.4.0'},
  {'v', 'MacVim'},
  {'e', 'Evernote'},
  {'t', 'iTerm2'},
  {'s', 'Slack'},
  {'n', 'MacDown'},
  {'l', 'Calendar'},
  {'d', 'Google Play Music Desktop Player'},
  {'p', 'Microsoft PowerPoint'},
  {'q', 'Preview'},
  {'c', 'Google Chrome'},
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
  -- k.triggered = true
end



for i, app in ipairs(singleapps) do
  -- k:bind({}, app[1], "pressed", function() launch(app[2]); k:exit(); end, nil, nil)
  k:bind({}, app[1], function() focus(app[2]); end)
end

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedHyper = function()
  -- k.triggered = false
  -- hs.alert("Hyper mode entered")
  k:enter()
end

-- -- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- --   send ESCAPE if no other keys are pressed.
releasedHyper = function()
  -- hs.alert("Hyper mode exited")
  k:exit()
  -- if not k.triggered then
  --   hs.eventtap.keyStroke({}, 'ESCAPE')
  -- end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedHyper, releasedHyper)

hs.hotkey.bind({"ctrl", "shift"}, 'l', hs.caffeinate.startScreensaver)

------------------------------------
-- Window management
------------------------------------

hs.window.animationDuration = 0 -- disable animations

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
  -- local cur_screen = hs.screen.primaryScreen()
  -- local next_screen = cur_screen:next()
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

k:bind({}, '-', leftHalf)
k:bind({}, '=', rightHalf)
k:bind({}, 'f', fullScreen)
k:bind({}, "'", throwRight)
k:bind({}, ";", throwLeft)

-------------------------------------------

-- Defeat paste-blocking
hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

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

local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/config/dotfiles/hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

