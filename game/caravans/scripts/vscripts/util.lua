function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end
function StringStartsWith(fullstring, substring)
    local strlen = string.len(substring)
    local first_characters = string.sub(fullstring, 1 , strlen)
    return (first_characters == substring)
end

function SendErrorMessage(playerID, message)
   CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "custom_error_message", {message=message}) 
end

function DistanceBetweenPoints(v1,v2)
    return math.sqrt(math.pow(v2.x - v1.x,2) + math.pow(v2.y - v1.y,2) )
end