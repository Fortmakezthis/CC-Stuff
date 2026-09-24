--This doesn't fully replicate a DHD yet. It also sucks.

local gate = peripheral.find("advanced_crystal_interface") or peripheral.find("crystal_interface") or peripheral.find("basic_crystal_interface")

if not gate then
    print("No Interface detected!")
    return
end

peripheral.wrap("modem", rednet.open)

local clockwise = false

while true do
    local event, side, channel, replyChannel, payload, distance = os.pullEvent("modem_message")
    if event == nil then
        goto continue
    end

    local message = payload.message
    local protocol = payload.sProtocol

    if distance < 86 then
        if protocol == "encode" then
            print("Encoding symbol " .. message .. "...")
            if clockwise then
                clockwise = false
                gate.rotateClockwise(tonumber(message))
            else
                clockwise = true
                gate.rotateAntiClockwise(tonumber(message))
            end
            gate.engageSymbol(tonumber(message))
        elseif protocol == "engage" then 
            print("Engaging Stargate...")
            gate.engageStargate()
        elseif protocol == "disconnect" then
            print("Disengaging wormhole...")
            gate.disconnectStargate()
        end
    end

    ::continue::
end