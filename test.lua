scriptId = 'com.thalmic.scripts.passes'

function enterpass()
    myo.keyboard("u", "press", "control", "shift")
end

function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

-- Unlock mechanism

function unlock()
    enabled = true
    extendUnlock()
end

function extendUnlock()
    enabledSince = myo.getTimeMilliseconds()
end


-- Triggers

function onPoseEdge(pose, edge)
    if pose == "thumbToPinky" then
        if edge == "off" then
            enabled = true
            enabledSince = myo.getTimeMilliseconds()
        elseif edge == "on" and not enabled then
            -- Vibrate twice on unlock
            myo.vibrate("short")
            myo.vibrate("short")
        end
    end

    if enabled and edge == "on" then
        pose = conditionallySwapWave(pose)

        if pose == "waveOut" then
            myo.vibrate("short")
            enabled = false
            enterpass()
        end
        if pose == "waveIn" then
            myo.vibrate("short")
            enabled = false
            enterpass()
        end
        if pose == "fist" then
            myo.vibrate("short")
            enabled = false
            enterpass()
        end
        if pose == "fingersSpread" then
            myo.vibrate("medium")
            enabled = true
            enterpass()
        end
    end
end

-- All timeouts in milliseconds
ENABLED_TIMEOUT = 2200
currentYaw = 0
currentPitch = 0

function onPeriodic()
    if enabled then

        if myo.getTimeMilliseconds() - enabledSince > ENABLED_TIMEOUT then
            enabled = false
        end
    end
end

function onForegroundWindowChange(app, title)
    --myo.debug(title)
	enable = true
	if string.match(title, "Chrome") then
	return true
	end
end


