
local is_online   = false
local lte_checked = false
local lte_volume  = -1

function conky_is_athene_online()
    local updates    = tonumber(conky_parse('${updates}'))  -- update counter from conky
    local c_interval = 2    -- update interval (in seconds)
    local interval   = 300  -- update interval of this script (in seconds)

    if (updates * c_interval) % interval == 0 then
        local t = os.execute("ping -q -c 1 -w 3 athene")
        if t ~= 0 then
            is_online = false
        else
            is_online = true
        end
    end

    if is_online then
        return "Online"
    else
        return "Offline"
    end
end

function conky_lte_volume()
    local updates    = tonumber(conky_parse('${updates}'))  -- update counter from conky
    local c_interval = 2    -- update interval (in seconds)
    local interval   = 3600 -- update interval of this script (in seconds)
    local lte_max    = 60   -- maximum volume in GB

    if ((updates * c_interval) % interval == 0) and (lte_checked == false) then
        lte_checked = true

        local file = io.popen("curl --user-agent 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0' 'pass.telekom.de'")
        local output = file:read("*a")
        file:close()

        local index_start = string.find(output, '<span class="colored">')
        local index_end   = string.find(output, '</span>', index_start)
        unit   = string.sub(output, index_end - 2,    index_end - 1)
        output = string.sub(output, index_start + 22, index_end - 5)
        output = string.gsub(output, ',', '.')
        output = tonumber(output)
        if unit == "MB" then -- convert to GB
            output = output / 1000
        end
        output = (100 * output) / lte_max
        lte_volume = math.modf(output)
    else
        lte_checked = false
    end

    if lte_volume ~= -1 then
        return lte_volume
    else
        return -1 -- error code
    end
end

