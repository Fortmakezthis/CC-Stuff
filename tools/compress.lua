local args = {...}
local to_compress = args[1]
local compress_to = args[2]
local decompress = args[3]

if not to_compress or not compress_to then
    print("Syntax:\ncompress <directory> <output> [decompress?]")
    return
end

if decompress ~= nil and decompress:lower() ~= "true" and decompress:lower() ~= "false" then
    print("[decompress?] must be a boolean! (true/false)")
    return
end

function compress_directory(directory)
    local contents = {}

    for _, file in ipairs(fs.list(directory)) do
        local ab_path = fs.combine(directory, file)

        if fs.isDir(ab_path) then
            contents[file] = compress_directory(ab_path)
        else
            local file_contents = fs.open(ab_path, "r")
            if file_contents then
                contents[file] = file_contents.readAll()
                file_contents.close()
            end
        end
    end

    return contents
end

function decompress_json(tree, directory)
    fs.makeDir(directory)

    for file, contents in pairs(tree) do
        local ab_path = fs.combine(directory, file)

        if type(contents) == "string" then
            local write_file = fs.open(ab_path, "w")
            write_file.write(contents)
            write_file.close()
        elseif type(contents) == "table" then
            decompress_json(contents, ab_path)
        else
            error("Contents of file " .. ab_path .. " in compressed directory " .. to_compress .. " are straight WRONG!")
        end
    end
end

if decompress:lower() == "false" or decompress == nil then
    local json_file = textutils.serializeJSON(compress_directory(to_compress))

    local file = fs.open(compress_to, "w")

    file.write(json_file)
    file.close()

    print("Compressed directory to " .. compress_to .. "!")
    return
else
    local json_file = fs.open(to_compress, "r")
    local json_directory = textutils.unserializeJSON(json_file.readAll())
    decompress_json(json_directory, compress_to)
    json_file.close()

    print("Successfully decompressed directory to " .. compress_to .. "!")
    return
end