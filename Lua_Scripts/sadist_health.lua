-- Get the address list from Cheat Engine
-- Assumes this is the address for the Sadist's Health
al = getAddressList()

-- Get the first memory record in the address list (index 0)
mr = addresslist_getMemoryRecord(al, 0)  -- Replace 0 with the index of the memory record you want

-- Get the initial value of the memory record (assuming it's a float value)
lastValue = tonumber(memoryrecord_getValue(mr))

-- Print the initial value to the console
if lastValue then
  print("Initial Value: " .. string.format("%.2f", lastValue))
else
  print("Initial Value not available")
  return -- Exit if the initial value is not available
end

-- Function to stop the timer and script when the value is 0 or below
function stopScript()
  if t1 then
    timer_setEnabled(t1, false)  -- Disable the timer
    print("Timer stopped. Script finished.")
  end
end

-- Function that runs every interval to check if the value has changed
function readValueTimer(t)
  -- Get the current value of the memory record
  local currentValue = tonumber(memoryrecord_getValue(mr))

  -- If the value is invalid or unavailable, safely exit the function
  if not currentValue then
    print("Current value not available. Stopping script.")
    stopScript()
    return
  end

  -- If the value is 0 or below, stop the script
  if currentValue <= 0 then
    print(string.format("Enemy health is %.2f or less. Stopping script.", currentValue))
    stopScript()
    return
  end

  -- If the value has changed, print the new value and the difference
  if currentValue ~= lastValue then
    local valueDifference = currentValue - lastValue
    print(string.format("Current Value: %.2f, Difference: %.2f", currentValue, valueDifference))
    lastValue = currentValue  -- Update lastValue to the current value
  end
end

-- Create a timer that checks the value periodically
t1 = createTimer(nil)
timer_setInterval(t1, 100)  -- Set the timer to check every 100 milliseconds (1/10th of a second)
timer_onTimer(t1, readValueTimer)  -- Assign the function to run on each timer tick
