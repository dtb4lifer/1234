local GameId = game.GameId;
local PlaceId = game.PlaceId;
local GG = getgenv();

return {
    Version = "2023_ACI_2026_HYPER";
    Function = function(selff, selc)
        if GameId == 2294168059 then
            for i=1, 6 do
                pcall(IB_NO_VIRTUALIZE(function()
                    local AC1 = selff:FindFirstChild("AntiFly", true) or selff:FindFirstChild("Anti-Fly", true) or selff:FindFirstChild("Anti-Speed", true) or selff:FindFirstChild("AntiSpeed", true);
                    local AC2 = selc:FindFirstChild("AntiFly", true) or selc:FindFirstChild("Anti-Fly", true) or selc:FindFirstChild("Anti-Speed", true) or selc:FindFirstChild("AntiSpeed", true);
                    if AC1 then AC1:Destroy(); end; if AC2 then AC2:Destroy(); end;
                end));
            end; if GG.UpperC and GG.LowerC then
                if PlaceId == 15962819441 then
                    local a=nil;a=GG.UpperC(game, "__namecall", newcclosure(IB_NO_VIRTUALIZE(function(self, ...)
                        local args, method, tos_self = {...}, getnamecallmethod(), tostring(self);
                        if method == "FireServer" then
                            if tos_self == "Sender" or tos_self == "Sender2" then
                                return wait(9e9);
                            end;
                        end; return a(self, ...);
                    end)));
                elseif PlaceId == 96354063422506 then
                    local str = string;
                    local ml,k,osi = {
                        GS = "GetService",
                        jfoik = "Players",
                        nIJM = "LocalPlayer",
                        mhfd = "PlayerGui",
                        j6yr = "ChildAdded",
                        paosd = "game",
                        mkas = "next",
                        p0ms = "getconnections",
                        nsjkd = 'Disable',
                        X19uYW1lY2FsbA = "__namecall",
                        X19pbmRleA = "__index",
                        mksdsdds = "Bypassed Anti Cheat [sUNC + Specific]",
                    }, getfenv(), GG;
                    local p,s,kd = k[ml.paosd], k[ml.mkas], osi[ml.p0ms];
                    local meta = "ReplicatedFirst.Loading.LocalScript";
                    for i,v in s , kd(p[ml.GS](p,ml.jfoik)[ml.nIJM][ml.mhfd][ml.j6yr]) do
                        if v then
                            v[ml.nsjkd](v);
                        end;
                    end; local old = nil; old = GG.UpperC(p,ml.X19uYW1lY2FsbA, newcclosure(IB_NO_VIRTUALIZE(function(self, ...)
                        local traceBACK,selfstring = debug.traceback(), tostring(self);
                        if str.find(traceBACK,meta,1,true) then return error(ml.mksdsdds); end;
                        if getnamecallmethod() == "FireServer" and not checkcaller() then
                            if str.find(selfstring,"Sender",1,true) or str.find(selfstring,"Sender2",1,true) then
                                return error(ml.mksdsdds);
                            end;
                        end; return old(self , ...);
                    end)));
                end;
            end;
        elseif GameId == 1235188606 then
            if getconnections then
                for _, v in ipairs(getconnections(selff.Idled)) do
                    v:Disable();
                end;
            else
                selff.Idled:Connect(IB_NO_VIRTUALIZE(function()
                    GG.VirtualInputManager:SendMouseButtonEvent(0,0,0, true, game, 1);
                    GG.VirtualInputManager:SendMouseButtonEvent(0,0,0, false, game, 1);
                end));
            end;
        elseif GameId == 5995470825 then
            local cV = game:GetService("ContentProvider");
            local o;o=GG.LowerC(game.FindService, newcclosure(function(self, a)
                if a == "VirtualUser" or a == "VirtualInputManager" or a == "UGCValidationService" then
                    return nil;
                end; return o(self, a);
            end));
            GG.LowerC(cV.PreloadAsync, newcclosure(function(...) end));
            GG.LowerC(cV.GetAssetFetchStatus, newcclosure(function(...)
                return Enum.AssetFetchStatus.None
            end));
        elseif GameId == 8795154789 then
            local o;o=GG.LowerC(game.FindService, IB_NO_VIRTUALIZE(function(self, a)
                if not checkcaller() then
                    if a == "VirtualUser" or a == "VirtualInputManager" or a == "UGCValidationService" then
                        return nil;
                    end;
                end; return o(self, a);
            end)); local str = string; for i, v in getgc(true) do
                if typeof(v) == 'function' and getinfo(v).name == 'compareTables' then
                    local gvinfo = getinfo(v);
                    if str.find(gvinfo.source, "Anti") then
                        local o;o=GG.LowerC(v, IB_NO_VIRTUALIZE(function()
                            return true;
                        end));
                    end;
                end;
            end;
        end; return true;
    end;
};
