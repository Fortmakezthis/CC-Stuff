local log = {}
 
function log.log(logData, path)
    if fs.exists(path) == false then
        local logFile = fs.open(path, "w")
        logFile.write({})
        logFile.close()
    end
    local logFile = fs.open(path, "r")
    local logsContent = logFile.readAll()
    local logs = textutils.unserialize(logsContent)
    if logs == nil then logs = {} end
    logFile.close()
    logFile = fs.open(path, "w")
    table.insert(logs, logData)
    logFile.write(textutils.serialize(logs))
    logFile.close()
end
 
return log