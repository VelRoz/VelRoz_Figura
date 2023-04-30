--input:    What the log will display to the console
--time:     The time to wait
function log_wait(input, time)
    if (world.getTime() % time == 0) then
        log(input)
    end
end