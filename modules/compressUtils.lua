local cmp = {}

--This doesn't actually compress yet, it only puts a directory into an archive file.
function cmp.compress_directory(directory)
    local contents = {}

    for _, file in ipairs(fs.list(directory)) do
        local ab_path = fs.combine(directory, file)

        if fs.isDir(ab_path) then
            contents[file] = cmp.compress_directory(ab_path)
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

--As mentioned earlier, this doesn't decompress either, it just extracts the archive into a directory.
function cmp.decompress_json(tree, directory)
    fs.makeDir(directory)

    for file, contents in pairs(tree) do
        local ab_path = fs.combine(directory, file)

        if type(contents) == "string" then
            local write_file = fs.open(ab_path, "w")
            write_file.write(contents)
            write_file.close()
        elseif type(contents) == "table" then
            cmp.decompress_json(contents, ab_path)
        else
            error("Contents of file " .. ab_path .. " in compressed directory are straight WRONG!")
        end
    end
    return true
end

function cmp.compress(to_compress, compress_to)
    local json_file = textutils.serializeJSON(cmp.compress_directory(tocompress))
    local file = fs.open(compress_to, "w")
    file.write(json_file)
    file.close()
    return true
end

function cmp.decompress(to_decompress, decompress_to)
    local json_file = fs.open(to_decompress, "r")
    local json_directory = textutils.unserializeJSON(json_file.readAll())
    cmp.decompress_json(json_directory, decompress_to)
    json_file.close()
    return true
end

return cmp