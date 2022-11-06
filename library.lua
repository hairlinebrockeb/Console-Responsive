local module = {}

getgenv().TabsMod = {}


function module:SetName(name)
    rconsolename(name.i)
end

TabsMod= getgenv().TabsMod
getgenv().breakload = true
getgenv().loadtabs = function()
    for _,tab in next,getgenv().TabsMod  do 
        for _i, tabv in next,tab do 
            print(type(tabv))
            if type(tabv) == 'string' then 
                rconsoleprint('\n['.._..']'..string.split(tabv,':')[2]..'\n')
            end
        end
    end
end
function module:AddTab(name,callback)
    tabtable  = {}
    table.insert(getgenv().TabsMod,tabtable)
    table.insert(tabtable,'tabname:'..name)
    table.insert(tabtable,callback)

    -- function tabtable:tab()
    --     k = {}
    --     table.insert(tabtable,k)
    -- end
end


getgenv().action = ''
function module:LoadClicks(self,args)
    game.StarterGui:SetCoreGuiEnabled(Enum. CoreGuiType. Backpack, true)
    -- local args = {...}
    game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
        if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Tool') ~= nil then -- and table.find(getgenv().tools,tool.name)
            getgenv().action = 'mouse1down'
            task.wait(.5)
            getgenv().action = ''
            pcall(function()
                local move = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Tool'):FindFirstChild('Move1').Value 
                getgenv()[move]()
            end)

        end
    end)
    game.Players.LocalPlayer:GetMouse().Button2Down:Connect(function()
        if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Tool') ~= nil then -- and table.find(getgenv().tools,tool.name)
            getgenv().action = 'mouse2down'
            task.wait(.5)
            getgenv().action = ''

            pcall(function()
                local move = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Tool'):FindFirstChild('Move2').Value 
                getgenv()[move]()
            end)
            

        end
    end)
end
function module:CreatePresetEyeTool(args)
    -- local args = {...}
    local Tool = Instance.new('Tool'); Tool.Parent = args[1];Tool.Name = args[2];
    local ToolMoves = Instance.new('StringValue',Tool); ToolMoves.Name = 'Move1' ToolMoves.Value = string.split(args[3],'-')[3]
    local ToolMoves2 = Instance.new('StringValue',Tool); ToolMoves2.Name = 'Move2'  ToolMoves2.Value = string.split(args[4],'-')[3]

end
module.load = function()
    rconsoleprint('@@YELLOW@@')
    loadtabs = getgenv().loadtabs
    loadtabs()
    task.spawn(function()
        while task.wait() do 
            if getgenv().breakload == true then 
                getgenv().breakload = false
                loadtabs()
                break
            end
            rconsoleprint('code: ')
            selection = rconsoleinput('option: ')
            rconsoleprint('\n')
            local function qfind(t) -- quick find 
                local ret = nil
                for _,v in next, t do 
                    if type(v) == 'string' then 
                        ret = string.split(v,':')[2]
                        break
                    end
                end
                return ret
            end
            local function ffind(t) -- function find 
                local ret = nil
                for _,v in next, t do 
                    if type(v) == 'function' then 
                        ret = v
                        break
                    end
                end
                return ret
            end -- tonumber(selection) and
            if  type(getgenv().TabsMod[tonumber(selection)]) == 'table' then 
                rconsoleclear()
                rconsoleprint('\n'..'Loaded: '..qfind(getgenv().TabsMod[tonumber(selection)])..'\n') -- check if its a tab
                rconsoleprint('@@GREEN@@')
                rconsoleprint('run option: ')
                rconsoleprint('\n[1] = run\n')
                rconsoleprint(string.rep('\n/\n',1))
                rconsoleprint('\n[2] = cancel\n')
                run_opt = rconsoleinput('option: ')
                if run_opt == '1' then 
                    print(ffind(getgenv().TabsMod[tonumber(selection)]))
                    ffind(getgenv().TabsMod[tonumber(selection)])()
                    rconsoleclear()
                    loadtabs()
                elseif run_opt == '2' then 
                    rconsoleprint('@@WHITE@@')
                    rconsoleprint('\nCancelled.')
                    rconsoleprint('Clearing in 3 seconds..')
                    local removing_r = 0
                    repeat 
                        task.wait(1)
                        removing_r+=1
                        rconsoleprint('  .')
                    until removing_r == 3
                    rconsoleclear()
                    rconsoleclear()
                    task.wait(.1)
                    loadtabs()
                end
            end
        end
    end)
end
