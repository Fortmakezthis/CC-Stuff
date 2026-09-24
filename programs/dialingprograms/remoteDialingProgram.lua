--This doesn't fully replicate a DHD yet. It also sucks.

peripheral.find("modem", rednet.open)

args = {...}
if #args < 1 then
    print("Syntax:\ndial <symbol>\ndial <engage>\ndial <disconnect>")
end

if tonumber(args[1]) then
    rednet.send(0, tonumber(args[1]), "encode")
    print("Chevron encoded!")
elseif args[1] == "engage" then
    rednet.send(0, nil, "engage")
    print("Stargate engaged!")
elseif args[1] == "disconnect" then
    rednet.send(0, nil, "disconnect")
    print("Stargate disconnected!")
end