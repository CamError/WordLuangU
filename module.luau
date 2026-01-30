--!strict
-- why am i making this lol | wordluangU basically allows for plain text programming, wow, so useful!

local lang = {}

local rt = {
    vars = {},
    funcs = {}
}

local function tokenetizeIdk(line: string)
    local tokenz = {}
    for token in line:gmatch("%S+") do
        table.insert(tokenz,token)
    end
    return tokenz
end

local function resolve(value)
    if tonumber(value) then
    return tonumber(value)

    if rt.vars[value] ~= nil then
        return rt.vars[value]
    end
    return value
end

local function evaluateIdk(tokenz)
    local left = resolve(tokenz[2])
    local op = tokenz[3]
    local right = resolve(tokenz[4])

    if op == ">" then return left > right end
    if op == "<" then return left < right end
	if op == "==" then return left == right end
	if op == "!=" then return left ~= right end
    return false
end