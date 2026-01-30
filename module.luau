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

local function execute(lines)
    local i = 1

    while i <= #lines do
        local line = lines[i]
        local tkenz = tokenetizeIdk(line)
        local cmd = tkenz[1]

        if cmd == "set" then
            rt.vars[tkenz[2]] = resolve(tkenz[4])
        
        elseif cmd == "say" then
            local out = {}
            for j = 2, #tkenz do
                table.insert(out,tostring(resolve(tkenz[j])))
            end
            print(table.concat(out,""))

        elseif cmd == "function" then
            local name = tkenz[2]
            rt.funcs[name] = {}
            i += 1

            while tokenetizeIdk(lines[i])[1] ~= "end" do
                table.insert(rt.funcs[name],lines[i])
                i += 1
            end
        
        elseif cmd == "if" then
            local conditionTr = evaluateIdk(tkenz)
            local blckTr = {}
            local blckFl = {}

            i += 1
            local active = blckTr

            while tokenetizeIdk(lines[i])[1] ~= "end" do
                if tokenetizeIdk(lines[i])[1] == "else" then
                    active = blckFl
                else
                    table.insert(active,lines[i])
                end
                i += 1
            end

            if conditionTr then
                execute(blckTr)
            else
                execute(blckFl)
            end
        
        elseif rt.funcs[cmd] then
            execute(rt.funcs[cmd])
        else
            warn("failed, unknown cmd:", cmd)
        end
        i += 1
    end
end

function langSpeak.run(scrText: string)
    local lines = {}
    for line in scrText:gmatch("[^\n]+") do
        table.insert(lines,line)
    end
    execute(lines)
end

return lang