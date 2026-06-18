local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[Plasma Hub] : Really? Your account is now at risk for the next ban wave."); end;

local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local Instancen = Instance.new;
local Vec3 = Vector3.new;
local Col3 = Color3;
local tble = table;
local str = string;
local math = math;
local CF = CFrame;
local tk = task;
local H = GG.H;
local W = GG.W;

local PlaceId = game.PlaceId;

local CFr = CF.new;
local IsA = game.IsA;
local twait = tk.wait;
local GetPivot = W.GetPivot;
local TwInfo = TweenInfo.new;
local VIM = GG.VirtualInputManager;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local FindFirstChild = game.FindFirstChild
local FindFirstChildOfClass = game.FindFirstChildOfClass;
local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA;
local FindFirstAncestorOfClass = game.FindFirstAncestorOfClass;

local RED = Col3.new(1,0,0);
local GREEN = Col3.new(0, 1, 0);
local BLUE = Col3.new(0, 0, 1);
local WHITE = Col3.new(1, 1, 1);
local YELLOW = Col3.new(1, 1, 0);
local ORANGE = Col3.fromRGB(255, 165, 0);

local VEC4 = Vec3(4,4,4);
local VEC7 = Vec3(7,7,7);
local VEC100 = Vec3(1,0,0);
local CFR100 = CFr(1,0,0);
local CFR400 = CFr(4,0,0);
local GSTORE_CFRAME = CFr(-15, 139, 221);

local UnsafePoses = {
    Vec3(-737, 865, -5322);
    Vec3(-2964, 278, -1594);
    Vec3(-2724, 454, -993);
    Vec3(999, 307, 744);
    Vec3(1117, 203, 882);
    Vec3(-399, 867, -5310);
    Vec3(-254, 202, -733);
    Vec3(10, 106, -737);
};

local ScriptData = {
    AutoData = {};
};

local PEID = {5777228223};

GG.Configs = GG.Configs or {
    ["Base"] = {
        ["Eggs"]={};
        ["Sell"]={
            ["Mode"] = "Food";
            ["World"] = "Lobby";
        };
    };
    ["Automation"] = {
        ["ForceSync"] = false;
        ["Guild"] = {};
        ["Mobs"] = {};
        ["Eggs"] = {};
        ["Level"] = {};
        ["Food"] = {};
        ["Resources"] = {};
        ["BoneMeal"] = {};
        ["Treasures"] = {};
    };
    ["Events"] = {
        ["Valentine's"] = {};
        ["Galaxy"] = {
            ["Unlock Sections"] = false;
        };
    };
    ["Client"] = {
        ["Client"] = {};
        ["Dragon"] = {};
    };
};

local Storing_AUTHENTICATION, PremiumCheck = nil, false;
local encrypt = function(text, key)
    local encryptedText = ""; for i = 1, #text do
        local char = str.byte(text, i);
        local encryptedChar = (char + key) % 256;
        encryptedText = encryptedText .. str.char(encryptedChar);
    end; return encryptedText;
end;
local decrypt = function(encryptedText ,key)
	local decryptedText = ""; for i = 1, #encryptedText do
		local char = str.byte(encryptedText, i);
		local decryptedChar = (char - key) % 256;
		if decryptedChar < 0 then
			decryptedChar = decryptedChar + 256;
		end; decryptedText = decryptedText .. str.char(decryptedChar);
	end; return decryptedText;
end;

return {
    Version = "DA_V3.34";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, PromptPackage, CoruTask, ESPF, CommonF, DAPackage)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;
        local GalaxyF           = nil;

        local Seat              = nil;
        local Cam               = W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local Backpack          = selff.Backpack;
        local PSG               = selff.PlayerGui;
        local selc              = selff.Character or selff.CharacterAdded:Wait();
        local HumSelf           = FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf.RootPart;

        local ChestNum          = 0;
        local SYNC_UPVS         = nil;
        local isSyncedFlagged   = false;
        local cmdm              = selff:GetMouse();
        local BaseCon           = GG.Configs.Base;
        local EventsCon         = GG.Configs.Events;
        local AutoCon           = GG.Configs.Automation;
        local ClientCon         = GG.Configs.Client.Client;
        local TRInfo            = TwInfo(0.3);
        local GameData          = {};
        local LConList          = {"Food","Resources", "BoneMeal"};
        local WorldList         = {"Lobby", "Grassland", "Jungle", "Volcano", "Tundra", "Ocean", "Desert", "Fantasy", "Toxic", "Prehistoric", "Shinrin"};
        local WorldId           = {Lobby=3475397644, Grassland=3475419198, Jungle=3475422608, Volcano=3487210751, Tundra=3623549100, Ocean=3737848045, Desert=3752680052, Fantasy=4174118306, Toxic=4728805070, Prehistoric=4869039553, Shinrin=125804922932357};

        local dist              = CommonF.dist;

        local WSettings         = WaitForChild(W, "WorldSettings", 9e9);
        local WWorld            = WaitForChild(WSettings, "World", 9e9);

        local SData             = WaitForChild(selff, "Data", 9e9);
        local SDDragon          = WaitForChild(SData, "Dragons", 9e9);
        local SDResource        = WaitForChild(SData, "Resources", 9e9);
        local SSettings         = WaitForChild(selff, "Settings", 9e9);

        local GInteractions     = WaitForChild(W, "Interactions", 9e9);
        local GRidingRings      = not tble.find(PEID, PlaceId) and WaitForChild(GInteractions, "RidingRings", 9e9);

        local RRemotes          = WaitForChild(R, "Remotes", 9e9);
        local SRemotes          = WaitForChild(selff, "Remotes", 9e9);

        local DBL               = WaitForChild(WaitForChild(WaitForChild(WaitForChild(WaitForChild(PSG, "HUDGui", 9), "BottomFrame", 9), "CurrentDragonFrame", 9), "StatusBars", 9), "DragonBreathLabel", 9);

        local OParams           = OverlapParams.new();
        OParams.FilterType      = Enum.RaycastFilterType.Include;
        OParams.MaxParts        = 1;
        
        local Functions         = {};

        local RE = {
            BondingExpRemote                = WaitForChild(SRemotes, "BondingExpRemote", 9e9);
            WorldTeleportRemote             = WaitForChild(RRemotes, "WorldTeleportRemote", 9e9);
            PoppedDiscoverIndicatorRemote   = WaitForChild(RRemotes, "PoppedDiscoverIndicatorRemote", 9e9);
            SellItemRemote                  = PlaceId == 3475397644 and WaitForChild(RRemotes, "SellItemRemote", 9e9);
            CollectEggRemote                = not tble.find(PEID, PlaceId) and WaitForChild(RRemotes, "CollectEggRemote", 9e9);
            SetCollectEggRemote             = not tble.find(PEID, PlaceId) and WaitForChild(RRemotes, "SetCollectEggRemote", 9e9);
        };

        local OriginalGameData = {
            ["Lobby"] = {
                ["Food"] = { "BrownFish", "PinkAngelfish", "Lemon", "Apple", "Corn", "Goldfish", },
                ["Resources"] = { "Wood", "Leaf", "AppleSeed", "Copper", },
            },
            ["Grassland"] = {
                ["Food"] = { "GreenAngelfish", "Pear", "RainbowArapaima", "Carrot", "Strawberry", "GrasslandFish", },
                ["Resources"] = { "CarrotSeed", "Stone", "Honeycomb", "Petal", },
            },
            ["Jungle"] = {
                ["Food"] = { "Long-Nose", "Broccoli", "JungleFish", "Peach", "BlueFish", "Potato", },
                ["Resources"] = { "PeachSeed", "Aloe", "Bamboo", "Quartz", },
            },
            ["Volcano"] = {
                ["Food"] = { "Cherry", "DragonFin", "Banana", "Mushroom", "SunWhale", "SunriseCrab", },
                ["Resources"] = { "BananaSeed", "LavaCrystal", "Coal", "IronWood", },
            },
            ["Tundra"] = {
                ["Food"] = { "Blueberry", "Almond", "Onion", },
                ["Resources"] = { "Icicle", "OnionSeed", "IceCrystal", "Snow", },
            },
            ["Ocean"] = {
                ["Food"] = { "Kelp", "BlueWhale", "Grapes", "GemtoothedPiranha", "Watermelon", "DeepSeaCrab", },
                ["Resources"] = { "WatermelonSeed", "SeaStar", "MagicCrystal", "Shell", },
            },
            ["Desert"] = {
                ["Food"] = { "PricklyPear", "DesertRay", "SandFish", "Pumpkin", "Chili", "GreatHornedEel", },
                ["Resources"] = { "Sandstone", "Sand", "CactusPiece", "PumpkinSeed", },
            },
            ["Fantasy"] = {
                ["Food"] = { "GlowingMushroom", "Pineapple", "RainbowPirahna", "CottonCandy", "HoloMantaRay", "Mothback", },
                ["Resources"] = { "FairyJar", "PineappleSeed", "Amethyst", "Blossom", },
            },
            ["Toxic"] = {
                ["Food"] = { "RadioactiveSquid", "JuniperBerry", "Lime", "GreatWhiteShark", "ToxicEel", "Dragonfruit", },
                ["Resources"] = { "DragonfruitSeed", "FellCrystal", "ConcentratedPoison", "ToxicWaste", },
            },
            ["Prehistoric"] = {
                ["Food"] = { "SabertoothWhale", "GlowRay", "AncientSquid", "Coconut", "CacaoBean", "Avacado", },
                ["Resources"] = { "Fossil", "CoconutSeed", "Geode", "Amber", },
            },
            ["Shinrin"] = {
                ["Food"] = { "MistSudachi", "KajiFruit", "Maguro", "Koi", "Edamame", },
                ["Resources"] = { "Spiritwood", "Limestone", "MistCrystal", },
            },
        };

        local function serialize(tbl)
            local buffer = { "{\n" };
            for _, world in ipairs(WorldList) do
                local data = tbl[world];
                if data then
                    tble.insert(buffer, ('    [%q] = {\n'):format(world));
                    tble.insert(buffer, '        ["Food"] = { ');
                    for _, food in ipairs(data.Food or {}) do
                        tble.insert(buffer, ('%q, '):format(food));
                    end; tble.insert(buffer, "},\n");
                    tble.insert(buffer, '        ["Resources"] = { ');
                    for _, resource in ipairs(data.Resources or {}) do
                        tble.insert(buffer, ('%q, '):format(resource));
                    end; tble.insert(buffer, "},\n");
                    tble.insert(buffer, "    },\n");
                end;
            end; tble.insert(buffer, "}");
            return tble.concat(buffer);
        end;

        Functions.SetSync = IB_NO_VIRTUALIZE(function(self)
            if self.SetupSync then return; end; self.SetupSync = true;
            if userIdentify.unc_infos.require ~= "Lua" then
                local SYNC_MODL = require(WaitForChild(WaitForChild(R, "_replicationFolder"), "NotificationsClient"));
                SYNC_UPVS = getupvalues(SYNC_MODL.Notify);
            else
                local SYNC_RE;SYNC_RE = R.Remotes.NotificationRemote.OnClientEvent:Connect(function(SYNC_KEY)
                    if SYNC_KEY == "DataSync" then
                        isSyncedFlagged = true;
                        SYNC_RE:Disconnect();
                        SYNC_RE = nil;
                    end;
                end);
            end;
        end);
        Functions.isSynced = IB_NO_VIRTUALIZE(function()
            if SYNC_UPVS then
                if (SYNC_UPVS[1] and SYNC_UPVS[1].DataSync) or AutoCon.ForceSync then
                    return true;
                else
                    return false;
                end;
            else
                if isSyncedFlagged or AutoCon.ForceSync then
                    return true; 
                end;
            end;
        end);
        Functions.LAutoCon = IB_NO_VIRTUALIZE(function(self, sec, autoActivate)
            local isFoundTrue = false;
            for i, v in pairs(LConList) do
                local config = AutoCon[v];
                if config and config[sec] then
                    isFoundTrue = true;
                    if autoActivate then
                        if sec == "Auto" then
                            self:CollectNode(v);
                        else
                            self.ESPNodes(v);
                        end;
                    else
                        break;
                    end;
                end;
            end; return isFoundTrue;
        end);
        Functions.IChestPos = IB_NO_VIRTUALIZE(function(self)
            if not FindFirstChild(GInteractions.Nodes, "Treasure") then return; end;

            self.ChestPoses = {};
            for _,v in pairs(GInteractions.Nodes.Treasure:GetAttributes()) do
                if typeof(v) == 'CFrame' then
                    tble.insert(self.ChestPoses, v);
                end;
            end;

            self.ChestCached = {};
            for i,v in pairs(self.ChestPoses) do
                local part = Instance.new("Part", W); part.Anchored = true;
                self.ChestCached[v] = part; part.CFrame = v;
                part.Name = "TreasureSpawnPosition";
            end;
        end);
        Functions.SwitchWorld = IB_NO_VIRTUALIZE(function(world)
            local TeleportPart = GInteractions.WorldTeleports.TeleportPad.Part;
            if dist(TeleportPart.Position) > 30 then
                CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = TeleportPart.CFrame};
                }); twait(1); if dist(TeleportPart.Position) <= 30 then
                    RE.WorldTeleportRemote:InvokeServer(WorldId[world or BaseCon.Sell.World], {});
                end;
            else
                return true;
            end;
        end);
        Functions.GetBase = IB_NO_VIRTUALIZE(function(player)
            local Var_2 = player and player.Name;
            if not Var_2 then Var_2 = selff.Name; end;
            local Var_1 = W and FindFirstChild(W, "Interactions") or false;
            Var_1 = Var_1 and FindFirstChild(Var_1, "Plots") or false;
            Var_1 = Var_1 and FindFirstChild(Var_1, "Plots") or false;
            Var_1 = Var_1 and FindFirstChild(Var_1, Var_2 .. "_Plot") or false;
            return Var_1;
        end);
        Functions.GetSEggs = IB_NO_VIRTUALIZE(function()
            local tbl = {}; for _, v in pairs(GetChildren(selff.Data.Eggs)) do
                if v and v.Value > 0 then
                    tble.insert(tbl, v.Name);
                end;
            end; return tbl;
        end);
        Functions.Incubate = IB_NO_VIRTUALIZE(function()
            if not Configs.Base.Eggs.Select then return; end;
            local Base = Functions.GetBase(); if not Base then return; end;
            for _,v in pairs(GetChildren(Base.Base.Buildings)) do
                if str.find(v.Name, "Incubator") and not FindFirstChild(v, "Egg") then
                    return v.IncubateRemote:InvokeServer(Configs.Base.Eggs.Select);
                end;
            end;
        end);
        Functions.Hatch = IB_NO_VIRTUALIZE(function()
            local Base = Functions.GetBase(); if not Base then return; end;
            for _,v in pairs(GetChildren(Base.Base.Buildings)) do
                if str.find(v.Name, "Incubator") and FindFirstChild(v, "Egg") and FindFirstChild(v.Egg, "Egg") then
                    if FindFirstChild(v.Egg.Egg, "Interact") and v.Egg.Egg.Interact.Glow.Enabled then
                        return v.ClaimRemote:InvokeServer();
                    end;
                end;
            end; return;
        end);
        Functions.IsValue8000 = IB_NO_VIRTUALIZE(function(varbase)
            return varbase and varbase.Value >= 6000;
        end);
        Functions.GoToGeneralStore = IB_NO_VIRTUALIZE(function()
            if WWorld.Value ~= "Lobby" then return; end;
            if dist(GSTORE_CFRAME.Position) > 30 then
                CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = GSTORE_CFRAME};
                }); twait(1); if dist(GSTORE_CFRAME.Position) <= 30 then
                    return true;
                end;
            end; return true;
        end);
        Functions.AutoSell = IB_NO_VIRTUALIZE(function(self)
            local Data = GameData[BaseCon.Sell.World][BaseCon.Sell.Mode];
            for i,v in pairs(Data) do
                if not BaseCon.Sell.Auto then return; end;
                local GObject = FindFirstChild(SDResource, v);
                if GObject then
                    if self.IsValue8000(GObject) and WWorld.Value ~= "Lobby" and BaseCon.Sell.AllowLobbyTP then
                        self.SwitchWorld("Lobby"); twait(60);
                    else
                        if self.GoToGeneralStore() and GObject.Value >= 1 and WWorld.Value == "Lobby" then
                            RE.SellItemRemote:FireServer({ItemName = v, Amount=GObject.Value}); twait(1.5);
                        end;
                    end;
                end;
            end; if BaseCon.Sell.AllowWorldTP and WWorld.Value ~= BaseCon.Sell.World then
                self.SwitchWorld(); twait(60);
            end;
        end);
        Functions.SetDFly = IB_NO_VIRTUALIZE(function()
            if not Seat or not Seat.Parent then return false; end;
            if not Seat.Parent.Data.Flying.Value then
                CommonF:CKey(Enum.KeyCode.Space);
            end; return true;
        end);
        Functions.GetRRing = function()
            local nearDist, Object = math.huge, nil;
            for _, v in pairs(GetChildren(GRidingRings.CreatedRings)) do
                if v.Transparency < 0 then
                    local dista = dist(v.Position);
                    if dista <= nearDist then
                        nearDist = dista;
                        Object = v;
                    end;
                end;
            end; return Object;
        end;
        Functions.GetGNest = function()
            for _, v in pairs(GetChildren(GInteractions.Nodes.Eggs)) do
                if v.Name ~= "ActiveNodes" and FindFirstChild(v, "Nest") then
                    if dist(v.Nest.Value.Position) <= 40 then
                        return v;
                    end;
                end;
            end; return;
        end;
        Functions.Leveling = function(self, where)
            if not Seat or not Seat.Parent then return; end;
            if where == "Ride" then
                local RRing = self.GetRRing();
                if not RRing then return; end;
                return CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = RRing.CFrame};
                    info = TRInfo;
                });
            elseif where == "Bond" then
                return RE.BondingExpRemote:FireServer(SDDragon[Seat.Parent.Name], "Happy");
            elseif where == "Track" then
                local Nest = self.GetGNest();
                if not Nest then return; end;
                for i,v in pairs(GetChildren(SSettings.CurrentEggs)) do
                    if tostring(v.Value) == Nest.Name then
                        return RE.PoppedDiscoverIndicatorRemote:FireServer("EggNest", v);
                    end;
                end;
            end;
        end;
        Functions.GetGDrops = function()
            twait(0.5); for _, v in pairs(GetChildren(Cam)) do
                if FindFirstChild(v, "Handle") then
                    CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart;
                        goal = {CFrame = v.Handle.CFrame};
                        info = TRInfo;
                    });
                end;
            end;
        end;
        Functions.IsNodeSafe = IB_NO_VIRTUALIZE(function(TargetNode, Range)
            local GFood = GInteractions.Nodes.Food;
            local GResource = GInteractions.Nodes.Resources;
            local isFood = TargetNode:IsDescendantOf(GFood);
            local isResource = TargetNode:IsDescendantOf(GResource);
            local ForbiddenFolder = if isFood then GResource
                                    elseif isResource then GFood 
                                    else nil;
            
            if not ForbiddenFolder then return true; end;
            OParams.FilterDescendantsInstances = {ForbiddenFolder};
            OParams.BruteForceAllSlow = true;
            
            local targetPos = if IsA(TargetNode, "Model") then GetPivot(TargetNode).Position else TargetNode.Position;
            
            local results = W:GetPartBoundsInBox(
                CFr(targetPos),
                Vec3(Range, Range, Range),
                OParams
            );
            
            if #results > 0 then
                for i = 1, #results do
                    local part = results[i];
                    local topModel = part;
                    while topModel and topModel.Parent ~= ForbiddenFolder do
                        topModel = topModel.Parent;
                    end; if topModel and IsA(topModel, "Model") then
                        topModel:Destroy();  WindUI:Notify({
                            Title = "<font color='rgb(118, 0, 255)'>Anti Cheat</font>",
                            Content = "Area Cleaned: Removed conflicting node.",
                            Icon = "circle-alert",
                            Duration = 5,
                        });
                    end;
                end; return false;
            end;
            
            return true;
        end);
        Functions.IsPosSafe = IB_NO_VIRTUALIZE(function(Hitbox)
            for i,v in pairs(UnsafePoses) do
                if (v-Hitbox.Position).Magnitude < 200 then
                    return false;
                end;
            end; return true;
        end);
        Functions.GetGNode = IB_NO_VIRTUALIZE(function(self, name)
            for _, v in pairs(GetChildren(GInteractions.Nodes[name])) do
                local Hitbox = (v and IsA(v, "Model") and FindFirstChild(v, "Hitbox"));
                local BillboardPart = v and FindFirstChild(v, "BillboardPart", true);
                local Health = BillboardPart and FindFirstChild(BillboardPart, "Health");
                local Attachment = v and FindFirstChild(v, "Attachment", true);
                if Hitbox and BillboardPart and Health and Attachment then
                    if Health.Value ~= 0 then
                        if WWorld.Value == "Tundra" then
                            if Attachment.WorldCFrame.Y > 1 and Attachment.WorldCFrame.Y < 2000 then
                                return Hitbox.CFrame, BillboardPart, v;
                            end; continue;
                        end;
                        if WWorld.Value == "Prehistoric" then
                            if self.IsNodeSafe(v, 100) then
                                return Hitbox.CFrame, BillboardPart, v;
                            else
                                v:Destroy();
                                WindUI:Notify({
                                    Title = "<font color='rgb(118, 0, 255)'>Anti Cheat</font>",
                                    Content = "Deleted.",
                                    Icon = "circle-alert",
                                    Duration = 10,
                                });
                            end; continue;
                        elseif WWorld.Value == "Shinrin" then
                            if Attachment.WorldCFrame.Y <= 179 or not self.IsPosSafe(Hitbox) then
                                v:Destroy();
                                WindUI:Notify({
                                    Title = "<font color='rgb(118, 0, 255)'>Anti Cheat</font>",
                                    Content = "Deleted.",
                                    Icon = "circle-alert",
                                    Duration = 10,
                                });
                            else
                                return Hitbox.CFrame, BillboardPart, v;
                            end; continue;
                        end;
                        if Attachment.WorldCFrame.Y > 1 and Attachment.WorldCFrame.Y < 1000 then
                            return Hitbox.CFrame, BillboardPart, v;
                        end;
                        if name == "BoneMeal" and Attachment.WorldCFrame.Y > -45 and Attachment.WorldCFrame.Y < 1000 then
                            return Hitbox.CFrame, BillboardPart, v;
                        end;
                    end;
                end;
            end; return;
        end);
        Functions.ValidateNodeState = IB_NO_VIRTUALIZE(function(isTrue, Bill, HCF)
            return isTrue and FindFirstChild(Bill, "Health")
                and Bill.Health.Value > 0 and dist(HCF.Position) <= 20;
        end);
        Functions.ValidateBreath = IB_NO_VIRTUALIZE(function(num)
            return DBL and DBL.Visible and DBL.MoverLabel.Size.X.Scale > num;
        end);
        Functions.BreathFire = IB_NO_VIRTUALIZE(function(self, FireRE, Dragon)
            if not DBL then return false; end;
            if DBL.Visible and DBL.MoverLabel.Size.X.Scale <= 0.2 then
                FireRE:FireServer(false);
                while DBL.MoverLabel.Size.X.Scale < 0.98 do
                    twait(0.1);
                end;
            end; if not Dragon.Data.Fire.Value then
                FireRE:FireServer(true);
                twait(0.2);
            end; return self.ValidateBreath(0.2);
        end);
        Functions.FireNode = IB_NO_VIRTUALIZE(function(self, Dragon, Object, Type, cd, obj2)
            local PlaySoundRemote  = FindFirstChild(Dragon.Remotes, "PlaySoundRemote");
            local BreathFireRemote = FindFirstChild(Dragon.Remotes, "BreathFireRemote");
            if not PlaySoundRemote or not BreathFireRemote then return; end;
            if not obj2 then
                for i = 1, 5 do
                    if Object.Parent and PlaySoundRemote.Parent then
                        if self:BreathFire(BreathFireRemote, Dragon) and Dragon.Data.Fire.Value then
                            PlaySoundRemote:FireServer("Breath", Type, Object);
                        end;
                    end; twait(cd);
                end;
            else
                for i = 1, 5 do
                    if Object.Parent and PlaySoundRemote.Parent then
                        if self:BreathFire(BreathFireRemote, Dragon) and Dragon.Data.Fire.Value then
                            PlaySoundRemote:FireServer("Breath", Type, obj2);
                        end;
                    end; twait(cd);
                end;
            end; return BreathFireRemote and BreathFireRemote:FireServer(false);
        end);
        Functions.CollectNode = IB_NO_VIRTUALIZE(function(self, name)
            if not Seat or not Seat.Parent then return; end;
            local HCF, Bill, Model = self:GetGNode(name);
            local Dragon = Seat.Parent;
            if Dragon and HCF and Bill and Model then
                if not self.SetDFly() then
                    return;
                end; self.GetGDrops();
                if dist(HCF.Position) > 20 then
                    return CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart,
                        goal = {CFrame = HCF * CFR400},
                    }), AutoCon[name].Auto and self:CollectNode(name);
                else
                    while self.ValidateNodeState(AutoCon[name].Auto, Bill, HCF) do
                        self:FireNode(Dragon, Bill, "Destructibles", 0.5);
                    end; return self.GetGDrops();
                end;
            elseif Dragon and not HCF then
                if AutoCon.Roaming then
                    local ChestPoses = self.ChestPoses;
                    return CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart,
                        goal = {CFrame = ChestPoses[math.random(1, #ChestPoses)]};
                    });
                end;
            end; return;
        end);
        Functions.ESPNodes = IB_NO_VIRTUALIZE(function(name)
            local Nodes = GInteractions.Nodes[name];
            if name == "Eggs" then Nodes = Nodes.ActiveNodes end;
            local Color = if name == "Food" then ORANGE
                        elseif name == "Resources" then BLUE
                        elseif name == "Eggs" then GREEN
                        elseif name == "BoneMeal" then WHITE
                        else nil;
                        
            local children = GetChildren(Nodes);
            for i = 1, #children do
                local v = children[i];
                if v and not FindFirstChild(v, "BoxHandleAdornment") then
                    ESPF.ESP(name, v, Color, VEC4, false, false);
                end;
            end;
        end);
        Functions.GetGEgg = IB_NO_VIRTUALIZE(function()
            for _, v in pairs(GetChildren(GInteractions.Nodes.Eggs.ActiveNodes)) do
                local GEgg = v and FindFirstChild(v, "EggModel") or false;
                if GEgg and GEgg.Parent then
                    if FindFirstChild(GEgg, "CurrentPlayer") and FindFirstChild(GEgg, "CurrentBoosts") and FindFirstChild(GEgg, "Harvested") and GEgg.Harvested.Value ~= true then
                        return GEgg, GetPivot(GEgg);
                    end;
                end;
            end; return;
        end);
        Functions.FireEgg = IB_NO_VIRTUALIZE(function(self, EggModel, OCFrame, OBoost, OHarvest)
            if not EggModel or not EggModel.Parent then return; end;
            if dist(OCFrame.Position) <= 15 then
                if AutoCon.Eggs.SafeMode then
                    CommonF:CKey(Enum.KeyCode.E); twait(0.1);
                    while OBoost.Value < DAPackage.OBoost and dist(OCFrame.Position) <= 15 and not CoreDestroyed do
                        twait(1);
                    end; if OBoost.Value >= DAPackage.OBoost and dist(OCFrame.Position) <= 15 then
                        OHarvest.Value = true;
                        twait(1.5);
                    end;
                else
                    local targetEgg = self.GetGNest();
                    if not targetEgg then return; end;
                    targetEgg = targetEgg.Name;
                    RE.SetCollectEggRemote:InvokeServer(targetEgg);
                    while OBoost.Value < DAPackage.OBoost and dist(OCFrame.Position) <= 15 and not CoreDestroyed do
                        OBoost.Value = OBoost.Value + 1;
                        twait(1);
                    end; if not OHarvest.Value and dist(OCFrame.Position) <= 15 then
                        RE.CollectEggRemote:InvokeServer(targetEgg);
                    end;
                end;
            end;
        end);
        Functions.CollectEgg = IB_NO_VIRTUALIZE(function(self)
            if not Seat or not Seat.Parent then return; end;
            local EggModel, OCFrame = self.GetGEgg();
            if not EggModel or not EggModel.Parent then return; end;
            local OBoost = FindFirstChild(EggModel, "CurrentBoosts");
            local OHarvest = FindFirstChild(EggModel, "Harvested");
            if not OBoost or not OHarvest then return; end;
            self.SetDFly(); CommonF.Tween({
                primary = Seat and Seat.Parent.PrimaryPart,
                goal = {CFrame = OCFrame * CFR100},
            }); HumSelf:MoveTo(OCFrame.Position + VEC100);
            return twait(2), self:FireEgg(EggModel, OCFrame, OBoost, OHarvest);
        end);
        Functions.GetGMob = IB_NO_VIRTUALIZE(function()
            local Target, MaxDistance, distance, cf = nil, math.huge, nil, nil;
            for _,v in next, GetChildren(W.MobFolder) do
                if IsA(v, "Model") and FindFirstChildWhichIsA(v, "BasePart") then
                    local BPart = FindFirstChildWhichIsA(v, "BasePart");
                    local Mag = BPart and dist(BPart.Position);
                    local DeadValue = BPart and FindFirstChild(BPart, "Dead")
                    if DeadValue and not DeadValue.Value and Mag < MaxDistance then
                        MaxDistance = Mag;
                        Target = BPart;
                        cf = BPart.CFrame;
                        distance = Mag;
                    end;
                end;
            end; if not Target then
                for _,v in next, GetChildren(GInteractions.Nodes.Mobs.ActiveMobs.Global) do
                    local BPart = if IsA(v, "BasePart") then v else nil;
                    if BPart then
                        local Mag = BPart and dist(BPart.Position);
                        local DeadValue = BPart and FindFirstChild(BPart, "Dead")
                        if DeadValue and not DeadValue.Value and Mag < MaxDistance then
                            MaxDistance = Mag;
                            Target = BPart;
                            cf = BPart.CFrame;
                            distance = Mag;
                        end;
                    end;
                end;
            end; return Target, distance, cf;
        end);
        Functions.KillMob = IB_NO_VIRTUALIZE(function(self)
            local Mob, Distance, MobCF = self.GetGMob();
            local Dragon = Seat and Seat.Parent;
            local Speed = if Distance >= 100 then 2 else 0.0001;
            if not Dragon or not Mob then return; end;
            self.SetDFly(); self.GetGDrops();
            CommonF.Tween({
                primary = Seat and Seat.Parent.PrimaryPart;
                goal = {CFrame = MobCF * CFr(-25,25,0)};
                info = TwInfo(Speed);
            }); if Mob.Parent and dist(Mob.Position) <= 50 then
                local DeadValueBase = FindFirstChild(Mob, "Dead");
                while Seat and Mob.Parent and DeadValueBase and AutoCon.Mobs.Auto and not DeadValueBase.Value and dist(Mob.Position) <= 50 do
                    self:FireNode(Dragon, Mob, "Mobs", 0.25);
                end; return self.GetGDrops();
            end;
        end);
        Functions.ESPMobs = IB_NO_VIRTUALIZE(function()
            for _,v in next, GetChildren(W.MobFolder) do
                if IsA(v, "Model") and FindFirstChildWhichIsA(v, "BasePart") and not FindFirstChild(v, "BoxHandleAdornment") then
                    local BPart = FindFirstChildWhichIsA(v, "BasePart");
                    local Mag = BPart and dist(BPart.Position);
                    local DeadValue = BPart and FindFirstChild(BPart, "Dead");
                    if DeadValue and not DeadValue.Value then
                        ESPF.ESP("Mobs", v, RED, VEC4, false, false);
                    end;
                end;
            end;
        end);
        Functions.ChestTps = IB_NO_VIRTUALIZE(function()
            if not Functions.ChestPoses or #Functions.ChestPoses == 0 then return; end;
            ChestNum = if ChestNum >= #Functions.ChestPoses then 1 else ChestNum + 1;
            local targetCF = Functions.ChestPoses[ChestNum];
            if targetCF and Seat and Seat.Parent then
                Functions.SetDFly();
                CommonF.Tween({
                    primary = Seat.Parent.PrimaryPart,
                    goal = {CFrame = targetCF},
                });
            end;
        end);
        Functions.ESPChests = IB_NO_VIRTUALIZE(function(self)
            for _,v in pairs(self.ChestCached) do
                if not FindFirstChild(v, "BoxHandleAdornment") then
                    ESPF.ESP("Chests", v, YELLOW, VEC4);
                end;
            end;
        end);
        Functions.CollectGuildCoin = IB_NO_VIRTUALIZE(function(self)
            local tbl={}; for _,v in pairs(GetChildren(GInteractions.Nodes.CurrencyNodes.Spawned)) do
                if v.Name == "GuildCoin" then
                    local BP = FindFirstChild(v, "Part");
                    if BP then
                        tble.insert(tbl, {
                            obj = BP;
                            dist = dist(BP.Position);
                        });
                    end;
                end;
            end; tble.sort(tbl, function(a,b) return a.dist < b.dist end);
            if #tbl > 0 then
                for i=1, #tbl do
                    local v = tbl[i]; self.SetDFly(true);
                    if not v.obj or not v.obj.Parent then
                        continue;
                    end; CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart,
                        goal = {CFrame = v.obj.CFrame},
                        info = TwInfo(v.dist / 450, Enum.EasingStyle.Linear),
                    });
                end;
            else
                if AutoCon.Roaming then
                    local ChestPoses = self.ChestPoses;
                    return CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart,
                        goal = {CFrame = ChestPoses[math.random(1, #ChestPoses)]};
                    });
                end;
            end;
        end);
        Functions.GalaxyGetBattery = IB_NO_VIRTUALIZE(function()
            local tbl = {}; for _,v in pairs(GetChildren(GInteractions.Nodes.Batteries)) do
                if v.Name == "Battery" then
                    tble.insert(tbl, v);
                end;
            end; return tbl;
        end);
        Functions.GalaxyGetCrate = IB_NO_VIRTUALIZE(function()
            local tbl = {}; for _,v in pairs(GetChildren(GInteractions.Nodes.Crates)) do
                if v.Name == "EggCrate" then
                    tble.insert(tbl, v);
                end;
            end; return tbl;
        end);
        Functions.GalaxyGetGCrate = IB_NO_VIRTUALIZE(function()
            return GetChildren(GInteractions.Nodes.Keys)[1];
        end);
        Functions.GalaxyUnlockChamber = IB_NO_VIRTUALIZE(function()
            if not GalaxyF.Regenerated then return; end;
            Functions.SetDFly(true);
            CommonF.Tween({
                primary = Seat and Seat.Parent.PrimaryPart;
                goal = {CFrame = GalaxyF.SpawnPos};
            }); WindUI:Notify({
                Title = "<font color='rgb(0, 255, 0)'>Cave</font>",
                Content = "Unlocking sections.",
                Icon = "circle-alert",
                Duration = 12,
            }); twait(12);
            local Dragon = Seat and Seat.Parent;
            for i, data in ipairs(GalaxyF.GalaxyChamber) do
                local p1, p2 = data[1], data[2];
                while EventsCon.Galaxy["Unlock Sections"] and not CoreDestroyed do
                    local found = GalaxyF:ScanChamber(p1.Position, p2.Position);
                    local count = #found; if count <= 1 then
                        break;
                    end; Functions.SetDFly(true); CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart;
                        goal = {CFrame = p1};
                    }); twait(0.2);
                    local firstOre = found[1];
                    Functions:FireNode(Dragon, firstOre, "Ore", 0.3, {
                        firstOre.Parent.Parent.Name;
                        firstOre.Parent.Name;
                    }); twait();
                end; if EventsCon.Galaxy["Unlock Sections"] and not CoreDestroyed then
                    GalaxyF.Regenerated = false;
                end;
            end
        end);
        Functions.IsCarryingBattery = IB_NO_VIRTUALIZE(function()
            for _,v in pairs(GetChildren(W.Environment.Decorational)) do
                if v.Name == "CarryBattery" and GetAttribute(v, "Player") == selff.Name then
                    return true;
                end;
            end;
        end);
        Functions.CollectBattery = IB_NO_VIRTUALIZE(function(self)
            if self.IsCarryingBattery() then return true; end;
            for _,v in pairs(GetChildren(W.Terrain)) do
                if v.Name == "BatterySpawnAttachment" and v.Active.Value then
                    CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart;
                        goal = {CFrame = v.CFrame};
                    }); if dist(v.CFrame.Position) <= 30 and v.Active.Value then
                        RE.GrabBatteryRemote:FireServer(v); twait(2);
                        return self.IsCarryingBattery();
                    end;
                end;
            end; return false
        end);
        Functions.GalaxyEgg = IB_NO_VIRTUALIZE(function(self)
            if GalaxyF.Regenerated then return; end;
            local TargetCrate = self.GalaxyGetCrate()[1];
            local CratePivot = TargetCrate and GetPivot(TargetCrate);
            if not TargetCrate or not TargetCrate.Parent then return; end;
            local Lids = TargetCrate and FindFirstChild(TargetCrate, "Lids");
            while EventsCon.Galaxy.AutoEggs and not CoreDestroyed and not GalaxyF.Regenerated do
                if not TargetCrate or not TargetCrate.Parent or not Lids.Parent then
                    return;
                end;

                if not Lids.Right.Battery["Meshes/CargoCrate_Battery"].PointLight.Enabled or not Lids.Left.Battery["Meshes/CargoCrate_Battery"].PointLight.Enabled then
                    if self:CollectBattery() and not GalaxyF.Regenerated then
                        CommonF.Tween({
                            primary = Seat and Seat.Parent.PrimaryPart;
                            goal = {CFrame = CratePivot};
                        }); if dist(CratePivot.Position) <= 30 then
                            CommonF:CKey(Enum.KeyCode.E); twait(1);
                            if Lids.Right.Battery["Meshes/CargoCrate_Battery"].PointLight.Enabled and Lids.Left.Battery["Meshes/CargoCrate_Battery"].PointLight.Enabled then
                                twait(1.7); local EggModel = FindFirstChild(Cam, "CyberEggEggsModel");
                                if EggModel then
                                    CommonF.Tween({
                                        primary = Seat and Seat.Parent.PrimaryPart;
                                        goal = {CFrame = GetPivot(EggModel)};
                                    });
                                end;
                            end;
                        end;
                    end;
                end; twait(0.1);
            end;
        end);
        Functions.GalaxyKeyCrate = IB_NO_VIRTUALIZE(function(self)
            if GalaxyF.Regenerated then return; end;
            local TargetCrate = self.GalaxyGetGCrate();
            local CratePivot = TargetCrate and GetPivot(TargetCrate);

            local UnlockPart = TargetCrate and FindFirstChild(TargetCrate, "Unlocked");
            local UnlockAtta = UnlockPart and FindFirstChild(UnlockPart, "Unlocked");
            local UnlockedSound = UnlockPart and FindFirstChild(UnlockAtta, "Portal");

            if not TargetCrate or not TargetCrate.Parent or not UnlockedSound then
                return;
            end;

            while EventsCon.Galaxy.AutoGreenCrate and not CoreDestroyed and not GalaxyF.Regenerated do
                if not TargetCrate or not TargetCrate.Parent or not UnlockedSound.Parent or UnlockedSound.Playing then
                    break;
                end;

                if self:CollectBattery() and not GalaxyF.Regenerated then
                    CommonF.Tween({
                        primary = Seat and Seat.Parent.PrimaryPart;
                        goal = {CFrame = CratePivot};
                    }); if dist(CratePivot.Position) <= 30 and not UnlockedSound.Playing then
                        CommonF:CKey(Enum.KeyCode.E); twait(1);
                    end;
                end; twait(0.1);
            end;
        end);
        Functions.isMechaActivated = IB_NO_VIRTUALIZE(function(Lids)
            if not Lids then return false; end;
            for i = 1, 4 do
                local v = FindFirstChild(Lids, tostring(i));
                if v and v.Parent then
                    local Battery = FindFirstChild(v, "Battery");
                    local RBattery = Battery and FindFirstChild(Battery, "Meshes/CargoCrate_Battery");
                    if RBattery and RBattery.Transparency > 0 then
                        return true;
                    end;
                end;
            end; 
            return false;
        end);
        Functions.GalaxyMecha = IB_NO_VIRTUALIZE(function(self)
            if GalaxyF.Regenerated then return; end;
            local Mecha = FindFirstChild(GInteractions.Nodes, "Meteorite");
            if not Mecha or not self.SuperchargerKey or self.SuperchargerKey.Value > 0 then return; end;
            while Mecha and Mecha.Parent and self.SuperchargerKey.Value == 0 and not CoreDestroyed and EventsCon.Galaxy.AutoMecha do
                local Lids = FindFirstChild(Mecha, "Lids");
                if Lids and self.isMechaActivated(Lids) then
                    if self:CollectBattery() then
                        CommonF.Tween({
                            primary = Seat and Seat.Parent.PrimaryPart;
                            goal = {CFrame = self.MechaPos};
                        }); if dist(self.MechaPos.Position) <= 30 then
                            local REMechaMeteor = FindFirstChild(W.Terrain, "MechaMeteorSpawnAttachment");
                            REMechaMeteor = REMechaMeteor and FindFirstChild(REMechaMeteor, "UseBatteryRemote");
                            if REMechaMeteor then
                                REMechaMeteor:InvokeServer();
                            end;
                        end;
                    end;
                end; twait(0.1);
            end;
        end);
        Functions.GalaxyShower = IB_NO_VIRTUALIZE(function(self)
            if R.MeteorShowerActive.Value == 0 then return; end;
            local Found = GetChildren(self.MeteSpawned);
            for i = 1, #Found do
                if not EventsCon.Galaxy.AutoMeteorShower or CoreDestroyed then break; end;
                local v = Found[i]; if v and (v.Name == "LargeMeteor" or v.Name == "SmallMeteor") then
                    local AsteroidSand = FindFirstChild(v, "AsteroidSand");
                    local IsDead = AsteroidSand and FindFirstChild(AsteroidSand, "Dead");
                    if IsDead and not IsDead.Value then
                        local Dragon = Seat and Seat.Parent;
                        while AsteroidSand and AsteroidSand.Parent and IsDead and not IsDead.Value and EventsCon.Galaxy.AutoMeteorShower and not CoreDestroyed do
                            if dist(AsteroidSand.Position) > 50 then
                                CommonF.Tween({
                                    primary = Seat and Seat.Parent.PrimaryPart;
                                    goal = {CFrame = AsteroidSand.CFrame};
                                });
                            else
                                self:FireNode(Dragon, v, "Meteors", 0.3, AsteroidSand);
                            end; twait(0.1);
                        end; twait(1.8);
                    end;
                end;
            end;
        end);
        Functions.GalaxyTeleport = IB_NO_VIRTUALIZE(function(self, where, pointer)
            if where == "Battery" then
                local Battery = self.GalaxyGetBattery()[1];
                return Battery and CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = GetPivot(Battery)};
                });
            elseif where == "Crate" then
                local Crate = self.GalaxyGetCrate()[1];
                return Crate and CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = GetPivot(Crate)};
                });
            elseif where == "Ship" then
                local Ship = FindFirstChild(GInteractions.EventGalaxy.PowerShipObjective, "Spaceship");
                return Ship and CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = Ship.CFrame};
                });
            elseif where == "BatteryDep" then
                local Powerline = GInteractions.EventGalaxy.PowerShipObjective["PowerLine"..pointer];
                local Battery = Powerline and FindFirstChild(Powerline, "BatteryDeposit_"..pointer);
                return Battery and CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = Battery.BatteryDepositMesh.CFrame};
                });
            elseif where == "Mecha" then
                local Mecha = FindFirstChild(GInteractions.Nodes, "Meteorite");
                return Mecha and CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = GetPivot(Mecha)};
                });
            elseif where == "Boss" then
                CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = self.GALAXYBOSSZONE};
                });
            elseif where == "Green" then
                local Green = self.GalaxyGetGCrate();
                return Green and CommonF.Tween({
                    primary = Seat and Seat.Parent.PrimaryPart;
                    goal = {CFrame = GetPivot(Green)};
                });
            end;
        end);
        Functions.GalaxyESP = IB_NO_VIRTUALIZE(function(self)
            local GalaxCon = EventsCon.Galaxy;
            if GalaxCon["ESP Egg Crates"] then
                for _,v in pairs(self.GalaxyGetCrate()) do
                    if FindFirstChild(v, "BoxHandleAdornment") then continue; end;
                    ESPF.ESP("Crate", v, YELLOW, VEC4, false, false);
                end;
            end;
            if GalaxCon["ESP Batteries"] or GalaxCon["ESP Bombs"] then
                for _,v in pairs(GetChildren(GInteractions.Nodes.Batteries)) do
                    if GalaxCon["ESP Batteries"] and v.Name == "Battery" and not FindFirstChild(v, "BoxHandleAdornment") then
                        ESPF.ESP("Battery", v, YELLOW, VEC4, false, false);
                    elseif GalaxCon["ESP Bombs"] and v.Name == "CarryBomb" and not FindFirstChild(v, "BoxHandleAdornment") then
                        ESPF.ESP("Bomb", v, RED, VEC4, false, false);
                    end;
                end;
            end;
            if GalaxCon["ESP Shards Block"] or GalaxCon["ESP Gears Block"] or GalaxCon["ESP Bomb Block"] then
                for _,h in pairs(GetChildren(GInteractions.EventGalaxy.OreMining.Sections)) do
                    for _,v in pairs(GetChildren(h)) do
                        if GalaxCon["ESP Shards Block"] and GetAttribute(v, "OreType") == "Crystal" and not FindFirstChild(v, "BoxHandleAdornment") then
                            ESPF.ESP("Shard", v, GREEN, VEC7, false, true);
                        elseif GalaxCon["ESP Gears Block"] and GetAttribute(v, "OreType") == "GearOre" and not FindFirstChild(v, "BoxHandleAdornment") then
                            ESPF.ESP("Gear", v, ORANGE, VEC7, false, true);
                        elseif GalaxCon["ESP Bomb Block"] and GetAttribute(v, "OreType") == "BombBox" and not FindFirstChild(v, "BoxHandleAdornment") then
                            ESPF.ESP("BombBlock", v, RED, VEC7, false, true);
                        end;
                    end;
                end;
            end;
        end);
        Functions.UpdateGameData = IB_NO_VIRTUALIZE(function()
            if userIdentify.unc_infos.require == "Lua" then
                return setclipboard("Unsupported Executor.");
            end; local ItemModule, struct = require(R.Storage.Items.Items), {};
            for foodName, data in pairs(ItemModule.Food) do
                local world = data.Origin; if world then
                    struct[world] = struct[world] or {Food = {}; Resources = {}};
                    tble.insert(struct[world].Food, foodName);
                end;
            end; for reName, data in pairs(ItemModule.Resources) do
                local world = data.Origin; if world then
                    struct[world] = struct[world] or {Food = {}; Resources = {}};
                    tble.insert(struct[world].Resources, reName);
                end;
            end; return serialize(struct);
        end);

        ScriptData.AutoData = {
            ClientTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Click Minigame", EN2="Click the circle being show while collecting eggs.", TH1="กดมินิเกมอัตโนมัติ", TH2="กดวงกลมที่แสดงขณะเก็บไข่", Path="Client/Auto Click Minigame"},
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                        {type="Toggle", EN="Instant Prompt", EN2="On some prompt/maps, this can flag anti cheat so remember to turn it off when you have to.", TH1="กด Prompt เร็วขึ้น", TH2="กดพวกปุ่มที่มันขึ้นมาให้กดเร็วขึ้น (Class:Prompt)", Path="Client/Instant Prompt"},
                        {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="ลอย", TH2="ทำให้ตัวละครเดินบนอากาศได้", Path="Client/Float"},
                        {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="เดินทะลุกำแพง", TH2="ต้องอธิบายด้วยหรอ", Path="Client/Noclip"},
                        {type="Slider", EN="Walk Speed", EN2="Change the speed of your walk.", TH1="ความเร็วในการเดิน", TH2="ปรับความเร็วการเดิน", Value={Min=1, Max=100}, Path="Client/WalkSpeed"},
                        {type="Toggle", EN="Enable Walk Speed", EN2="Enable walk speed modification.", TH1="เปิดใช้งานความเร็วในการเดิน", TH2="ปรับความเร็วในการเดิน", Path="Client/Enable WalkSpeed"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                        {type="Slider", EN="Jump Power", EN2="Change the power of your jump.", TH1="ความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Value={Min=1, Max=300}, Path="Client/JumpPower"},
                        {type="Toggle", EN="Enable Jump Power", EN2="Enable jump power modification.", TH1="เปิดใช้งานความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Path="Client/Enable JumpPower"}, {type="Space"},
                    }, Title="Client", Open=true};
                }};
                {type="Group", dats={
                    {dat={
                        {type="Button", Title="Fetch Dragon Features", TH1="ดึงค่าจากมังกร", Callback=IB_NO_VIRTUALIZE(function()
                            function Slider(name, val)
                                local MaxVal, MinVal = 100, 0.1;
                                if val > 100 then
                                    MaxVal = val;
                                elseif val < 1 then
                                    MinVal = val;
                                end; return ScriptCache.DragonMod:Slider({
                                    Title = name; Value = {Min=MinVal,Max=MaxVal,Default=Configs.Client.Dragon[name] or val};
                                    Step=0.1; Callback = function(value)
                                        Configs.Client.Dragon[name] = value;
                                        if Seat and Seat.Parent then
                                            local GAYSX = FindFirstChild(Seat.Parent, name, true);
                                            if GAYSX then GAYSX.Value = value; end; return;
                                        else return WindUI:Notify({
                                            Title = "<font color='rgb(118, 0, 255)'>Guide</font>",
                                            Content = "Please sit on any dragon.",
                                            Icon = "circle-alert",
                                            Duration = 20,
                                        });
                                        end;
                                    end;
                                });
                            end; if Seat then
                                for i, v in pairs({
                                    Seat.Parent.Data.MovementStats.BoostFlyDashCooldown,
                                    Seat.Parent.Data.MovementStats.BoostSpeed,
                                    Seat.Parent.Data.MovementStats.BoostSpeedAdd,
                                    Seat.Parent.Data.MovementStats.BoostSpeedMultiplier,
                                    Seat.Parent.Data.MovementStats.Dash3TimeUseCooldown,
                                    Seat.Parent.Data.MovementStats.DashCooldown,
                                    Seat.Parent.Data.MovementStats.DashForce,
                                    Seat.Parent.Data.MovementStats.FlyDashCooldown,
                                    Seat.Parent.Data.MovementStats.FlySpeed,
                                    Seat.Parent.Data.MovementStats.JumpCooldown,
                                    Seat.Parent.Data.MovementStats.WalkSpeed,
                                    Seat.Parent.Data.MovementStats.WalkSpeedMultiplier,
                                    Seat.Parent.Data.CombatStats.BiteCooldown,
                                    Seat.Parent.Data.CombatStats.BiteRadius,
                                    Seat.Parent.Data.CombatStats.MaxHitsPerBite,
                                }) do
                                    if IsA(v, "IntValue") or IsA(v, "NumberValue") then
                                        Slider(v.Name, v.Value);
                                    end;
                                end; return;
                            else
                                return WindUI:Notify({
                                    Title = "<font color='rgb(118, 0, 255)'>Guide</font>",
                                    Content = "Please sit on any dragon.",
                                    Icon = "circle-alert",
                                    Duration = 20,
                                });
                            end; return;
                        end)},
                        {type="Button", EN="Godmode 1", EN2="Your dragon need to die to use this.", TH1="อมตะ 1", TH2="มังกรตายก่อนถึงจะใช้ได้", Callback=IB_NO_VIRTUALIZE(function()
                            for _, v in pairs(GetChildren(selc.Dragons)) do
                                if v and FindFirstChild(v, "Data") and FindFirstChild(v.Data, "Dead") then
                                    if v.Data.Dead.Value then
                                        v.Data.Dead.Value = false;
                                    end;
                                end;
                            end;
                        end)},
                        {type="Toggle", EN="Godmode 2", EN2="Required high UNC", TH1="อมตะ 2", TH2="ต้องใช้ตัวรันดีๆ ถึงจะใช้ได้", Path="Dragon/Godmode", Locked=not GG.UpperC}, {type="Space"}; {type="Space"};
                    }, Title="Dragon Modding", Global="DragonMod"};
                }};
            };
            BaseTab = {
                {type="Group", dats={
                    {dat={
                        {type="Dropdown", Title="Select Egg", TH1="เลือกไข่", AllowNone=true, Values={}, Path="Eggs/Select", RECall={
                            Title = "Refresh Eggs",
                            RECall = Functions.GetSEggs;
                        }};
                        {type="Button", EN="Incubate", EN2="You need to be in your plot.", TH1="เอาใส่หม้อ", TH2="ต้องยืนอยู่ใกล้ฐาน", Callback=Functions.Incubate};
                        {type="Button", EN="Hatch", EN2="You need to be in your plot. This will hatch any egg it found.", TH1="ฟักไข่", TH2="ต้องยืนอยู่ใกล้ฐาน, จะฟักทุกฟองที่สคริปเจออยู่ในหม้อ", Callback=Functions.Incubate};
                    }, Title="Eggs"};
                }}; {type="Space"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Dropdown", EN="Select Mode", EN2="Select which Mode you want to use.", TH1="เลือกโหมด", TH2="เลือกว่าจะใช้โหมดไหน", Values={"Food", "Resources"}, Path="Sell/Mode"};
                        {type="Dropdown", EN="Select World", EN2="Sell foods/resources depend on your selected world.", TH1="เลือกโลก", TH2="ขายของตามโลกที่คุณเลือก", Values={"Lobby", "Grassland", "Jungle", "Volcano", "Tundra", "Ocean", "Desert", "Fantasy", "Toxic", "Prehistoric", "Shinrin"}, Path="Sell/World"};
                        {type="Toggle", EN="Allow Lobby Teleport", EN2="Allow the script to teleport to lobby when hit backpack limit.", TH1="อนุญาตให้วาปกลับล็อบบี้", TH2="วาปไปล็อบบี้เมื่อเต็มกระเป๋า", Path="Sell/AllowLobbyTP"};
                        {type="Toggle", EN="Allow World Teleport", EN2="Allow the script to teleport to selected world after selling.", TH1="อนุญาตให้วาปไปโลก", TH2="วาปไปโลกที่เลือกไว้หลังจากขายของเสร็จ", Path="Sell/AllowWorldTP"};
                        {type="Toggle", Title="Auto Sell", TH1="ออโต้ขาย", TH2="ขายของอัตโนมัติ", Path="Sell/Auto"};
                    }, Title="Sell"};
                }};
            };
            AutomationTab = {
                {type="Toggle", EN="Force Synced", EN2="Forcing the script to know that your game data is synced.", TH1="บังคับให้ Synced", TH2="บังคับให้สคริปรู้ว่า sync ข้อมูลเกมแล้ว", Path="ForceSync"};
                {type="Toggle", EN="Auto Roaming", EN2="Fly around when there is no node nearby.", TH1="บินไปเรื่อยๆจนกว่าจะเจอจุดฟาม", TH2="บินไปเรื่อยๆ ตอนไม่มี Node ให้ฟาร์ม", Path="Roaming"}, {type="Space"}, {type="Space"},
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Collect Guild Coins", EN2="Fly around with your dragon and collect guild coins.", TH1="เก็บเหรียญกิลด์อัตโนมัติ", TH2="บินเก็บเหรียญกิลด์ด้วยมังกร", Path="Guild/Coins"}, {type="Space"},
                    }, Title="Guild"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Bond", EN2="", TH1="ความผูกพัน", TH2="เพิ่มค่าความผูกพัน", Path="Level/Bond"},
                        {type="Toggle", EN="Tracking", EN2="", TH1="ระดับการติดตาม", TH2="เพิ่มระดับการติดตาม", Path="Level/Tracking"},
                        {type="Toggle", EN="Riding", EN2="", TH1="ระดับการขี่", TH2="เพิ่มระดับการขี่", Path="Level/Riding"}, {type="Space"},
                    }, Title="Level"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Farm", EN2="Fly around with your dragon and collect foods.", TH1="ออโต้ฟาม", TH2="บินฟามอาหารด้วยมังกร", Path="Food/Auto"},
                        {type="Toggle", EN="ESP", EN2="Show food nodes.", TH1="ESP อาหาร", TH2="มองเห็น Node อาหาร", Path="Food/ESP", Callback=IB_NO_VIRTUALIZE(function(state)
                            AutoCon.Food.ESP = state; ESPF.Destroy("Food");
                        end)}, {type="Space"},
                    }, Title="Foods"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Farm", EN2="Fly around with your dragon and collect resources.", TH1="ออโต้ฟาม", TH2="บินฟามทรัพยากรด้วยมังกร", Path="Resources/Auto"},
                        {type="Toggle", EN="ESP", EN2="Show resource nodes.", TH1="ESP ทรัพยากร", TH2="มองเห็น Node ทรัพยากร", Path="Resources/ESP", Callback=IB_NO_VIRTUALIZE(function(state)
                            AutoCon.Resources.ESP = state; ESPF.Destroy("Resources");
                        end)}, {type="Space"},
                    }, Title="Resources"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Farm", EN2="Fly around with your dragon and collect bonemeals.", TH1="ออโต้ฟาม", TH2="บินฟามกระดูกด้วยมังกร", Path="BoneMeal/Auto"},
                        {type="Toggle", EN="ESP", EN2="Show bone nodes.", TH1="ESP กระดูก", TH2="มองเห็น Node กระดูก", Path="BoneMeal/ESP", Callback=IB_NO_VIRTUALIZE(function(state)
                            AutoCon.BoneMeal.ESP = state; ESPF.Destroy("BoneMeal");
                        end)}, {type="Space"},
                    }, Title="Bonemeals"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Farm", EN2="Fly around with your dragon and kill mobs.", TH1="ออโต้ฟาม", TH2="บินฟามมอนด้วยมังกร", Path="Mobs/Auto"},
                        {type="Toggle", EN="ESP", EN2="Show bone nodes.", TH1="ESP มอน", TH2="มองเห็น Node มอน", Path="Mobs/ESP", Callback=IB_NO_VIRTUALIZE(function(state)
                            AutoCon.Mobs.ESP = state; ESPF.Destroy("Mobs");
                        end)}, {type="Space"},
                    }, Title="Mobs"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Safe Mode", EN2="Disable networking type of auto collect.", TH1="เพิ่มความปลอดภัย", TH2="ปิดการใช้ระบบ RE/RF Direct ในการเก็บไข่", Path="Eggs/SafeMode"}, {type="Space"}, {type="Space"},
                        {type="Toggle", EN="Auto Farm", EN2="Fly around with your dragon and collect eggs.", TH1="ออโต้ฟาม", TH2="บินฟามไข่ด้วยมังกร", Path="Eggs/Auto"},
                        {type="Toggle", EN="ESP", EN2="Show egg nodes.", TH1="ESP ไข่", TH2="มองเห็น Node ไข่", Path="Eggs/ESP", Callback=IB_NO_VIRTUALIZE(function(state)
                            AutoCon.Eggs.ESP = state; ESPF.Destroy("Eggs");
                        end)},
                    }, Title="Eggs"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Teleport", EN2="Teleport to treasure with dragon.", TH1="วาปไปที่กล่องสมบัติ", TH2="วาปไปที่กล่องสมบัติด้วยมังกร", Callback=Functions.ChestTps},
                        {type="Toggle", EN="ESP", EN2="Show treasure nodes.", TH1="ESP กล่องสมบัติ", TH2="มองเห็น Node กล่องสมบัติ", Path="Treasures/ESP", Callback=IB_NO_VIRTUALIZE(function(state)
                            AutoCon.Treasures.ESP = state; ESPF.Destroy("Chests");
                        end)}, {type="Space"},
                    }, Title="Treasures"};
                }}; {type="Space"};
            };
            EventsTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Unlock Cave Boundaries", EN2="This is needed to bypass teleport/noclip in the cave.",TH1="ปลดล็อคพื้นที่ในเหมือง", TH2="ต้องเปิดเพื่อให้สามารถวาปและทะลุกำแพงได้", Path="Galaxy/Unlock Sections"};
                        {type="Toggle", EN="Auto Eggs", EN2="PowerUp crates & collect eggs.",TH1="ออโต้ไข่", TH2="ใส่ถ่านแล้วเก็บไข่", Path="Galaxy/AutoEggs"};
                        {type="Toggle", EN="Auto Green Crate", EN2="PowerUp crates.",TH1="ออโต้กล่องเขียว", TH2="ใส่ถ่านแล้วเปิดกล่องเขียวอัตโนมัติ", Path="Galaxy/AutoGreenCrate"};
                        {type="Toggle", EN="Auto Mecha Meteor", EN2="This function search your inventory for key and if it can't find the key, it will insert batteries to the mecha meteor.",TH1="ออโต้ Mecha Meteor", TH2="ค้นหากุญแจในกระเป๋าและใส่ถ่านใน Mecha Meteor", Path="Galaxy/AutoMecha"};
                        {type="Toggle", EN="Auto Meteor Shower", EN2="Auto collect meteor shower",TH1="ออโต้ฝนดาวตก", TH2="เก็บฝนดาวตกอัตโนมัติ", Path="Galaxy/AutoMeteorShower"};
                        {type="Button", EN="Reduce Lag", EN2="Remove decorations for 'Auto Eggs'", TH1="ลดแล็ค", TH2="ลบของตกแต่งให้ 'ออโต้ไข่'", Callback=IB_NO_VIRTUALIZE(function()
                            for _,v in pairs(GetChildren(W.Environment.Decorational)) do
                                if v.Name == "CarryBomb" or v.Name == "CarryBattery" then
                                    continue;
                                end; v:Destroy();
                            end;
                        end)}; {type="Space"}; {type="Space"};
                        {type="Button", EN="Teleport To Battery", EN2="Fastly tween to the battery", TH1="วาปไปที่ถ่าน", TH2="บินไปที่ถ่านด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("Battery");
                        end};
                        {type="Button", EN="Teleport To Egg Crate", EN2="Fastly tween to the egg crate", TH1="วาปไปที่ไข่", TH2="บินไปที่ไข่ด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("Crate");
                        end};
                        {type="Button", EN="Teleport To Spaceship", EN2="Fastly tween to the spaceship", TH1="วาปไปที่ยาน", TH2="บินไปที่ยานUFOด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("Ship");
                        end};
                        {type="Button", EN="Teleport To Mecha", EN2="Fastly tween to the mecha meteor", TH1="วาปไปที่ Mecha", TH2="บินไปที่ Mecha Meteor ด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("Mecha");
                        end};
                        {type="Button", EN="Teleport To Boss Waiting Zone", EN2="Fastly tween to the zone", TH1="วาปไปที่จุดรอตีบอส", TH2="บินไปที่จุดรอตีบอสด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("Boss");
                        end};
                        {type="Button", EN="Teleport To Green Crate", EN2="Fastly tween to the green crate", TH1="วาปไปที่กล่องเขียว", TH2="บินไปที่กล่องเขียวด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("Green");
                        end}; {type="Space"}; {type="Space"};
                        {type="Button", EN="Battery Deposite A", EN2="Fastly tween to the Capsule A", TH1="วาปไปที่ใส่ถ่าน A", TH2="บินไปที่ใส่ถ่านAด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("BatteryDep", "A");
                        end};
                        {type="Button", EN="Battery Deposite B", EN2="Fastly tween to the Capsule B", TH1="วาปไปที่ใส่ถ่าน B", TH2="บินไปที่ใส่ถ่านBด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("BatteryDep", "B");
                        end};
                        {type="Button", EN="Battery Deposite C", EN2="Fastly tween to the Capsule C", TH1="วาปไปที่ใส่ถ่าน C", TH2="บินไปที่ใส่ถ่านCด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("BatteryDep", "C");
                        end};
                        {type="Button", EN="Battery Deposite D", EN2="Fastly tween to the Capsule D", TH1="วาปไปที่ใส่ถ่าน D", TH2="บินไปที่ใส่ถ่านDด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("BatteryDep", "D");
                        end};
                        {type="Button", EN="Battery Deposite E", EN2="Fastly tween to the Capsule E", TH1="วาปไปที่ใส่ถ่าน E", TH2="บินไปที่ใส่ถ่านEด้วยความเร็ว", Callback=function()
                            Functions:GalaxyTeleport("BatteryDep", "E");
                        end}; {type="Space"}; {type="Space"};
                        {type="Toggle", Title="ESP Crates", TH1="ESP ไข่", Path="Galaxy/ESP Egg Crates", Callback=IB_NO_VIRTUALIZE(function(state)
                            EventsCon.Galaxy["ESP Egg Crates"] = state; ESPF.Destroy("Crate");
                        end)};
                        {type="Toggle", Title="ESP Batteries", TH1="ESP ถ่าน", Path="Galaxy/ESP Batteries", Callback=IB_NO_VIRTUALIZE(function(state)
                            EventsCon.Galaxy["ESP Batteries"] = state; ESPF.Destroy("Battery");
                        end)};
                        {type="Toggle", Title="ESP Bombs", TH1="ESP ระเบิด", Path="Galaxy/ESP Bombs", Callback=IB_NO_VIRTUALIZE(function(state)
                            EventsCon.Galaxy["ESP Bombs"] = state; ESPF.Destroy("Bomb");
                        end)};
                        {type="Toggle", EN="ESP Bomb Block", EN2="This is laggy.", TH1="ESP บล็อคระเบิด", TH2="อันนี้แล็คนิดนึง", Path="Galaxy/ESP Bomb Block", Callback=IB_NO_VIRTUALIZE(function(state)
                            EventsCon.Galaxy["ESP Bomb Block"] = state; ESPF.Destroy("BombBlock");
                        end)};
                        {type="Toggle", EN="ESP Shards Block", EN2="This is laggy.", TH1="ESP บล็อคชาร์ด", TH2="อันนี้แล็คนิดนึง", Path="Galaxy/ESP Shards Block", Callback=IB_NO_VIRTUALIZE(function(state)
                            EventsCon.Galaxy["ESP Shards Block"] = state; ESPF.Destroy("Shard");
                        end)};
                        {type="Toggle", EN="ESP Gears Block", EN2="This is laggy.", TH1="ESP บล็อคเกียร์", TH2="อันนี้แล็คนิดนึง", Path="Galaxy/ESP Gears Block", Callback=IB_NO_VIRTUALIZE(function(state)
                            EventsCon.Galaxy["ESP Gears Block"] = state; ESPF.Destroy("Gear");
                        end)};
                    }, Title="Galaxy"},
                }};
            };
        };

        CoruTask.New("Riding Leveling", function()
            while true do
                if not AutoCon.Level.Riding or CoreDestroyed then
                    CoruTask.Close("Riding Leveling");
                end; Functions:Leveling("Ride");
                twait(0.1);
            end;
        end);
        CoruTask.New("GAutomation 1", function()
            while true do
                if BaseCon.Sell.Auto then
                    Functions:AutoSell();
                end; if (not Functions:LAutoCon("Auto", true) and not AutoCon.Mobs.Auto and not AutoCon.Eggs.Auto and not BaseCon.Sell.Auto) or CoreDestroyed then
                    CoruTask.Close("GAutomation 1");
                end; if AutoCon.Mobs.Auto then
                    Functions:KillMob();
                end; if AutoCon.Eggs.Auto then
                    Functions:CollectEgg();
                end; twait(0.03);
            end;
        end);
        CoruTask.New("GESP 1", function()
            while true do
                if (not Functions:LAutoCon("ESP", true) and not AutoCon.Mobs.ESP and not AutoCon.Treasures.ESP) or CoreDestroyed then
                    CoruTask.Close("GESP 1");
                end; if AutoCon.Mobs.ESP then
                    Functions.ESPMobs();
                end; if AutoCon.Treasures.ESP then
                    Functions:ESPChests();
                end; if AutoCon.Eggs.ESP then
                    Functions.ESPNodes("Eggs");
                end; twait(1);
            end;
        end);
        CoruTask.New("Guild", function()
            while true do
                if not AutoCon.Guild.Coins or CoreDestroyed then
                    CoruTask.Close("Guild");
                end; Functions:CollectGuildCoin();
                twait(0.1);
            end;
        end);
        CoruTask.New("Galaxy", function()
            if PlaceId ~= 5777228223 then
                return;
            end; while true do
                if (not EventsCon.Galaxy["Unlock Sections"] and not EventsCon.Galaxy.AutoEggs and not EventsCon.Galaxy.Mecha and not EventsCon.Galaxy.AutoMeteorShower and not EventsCon.Galaxy.AutoGreenCrate) or CoreDestroyed then
                    CoruTask.Close("Galaxy");
                end;
                
                if EventsCon.Galaxy["Unlock Sections"] then
                    Functions.GalaxyUnlockChamber();
                end;
                if EventsCon.Galaxy.AutoEggs then
                    Functions:GalaxyEgg();
                end;
                if EventsCon.Galaxy.AutoMecha then
                    Functions:GalaxyMecha();
                end;
                if EventsCon.Galaxy.AutoMeteorShower then
                    Functions:GalaxyShower();
                end;
                if EventsCon.Galaxy.AutoGreenCrate then
                    Functions:GalaxyKeyCrate();
                end;
                twait(0.1);
            end;
        end);
        CoruTask.New("Galaxy ESP", function()
            if PlaceId ~= 5777228223 then
                return;
            end; while true do
                local Enabled = false;
                for _, v in pairs(GalaxyF.ESPPaths) do
                    if EventsCon.Galaxy[v] then
                        Enabled = true;
                        break;
                    end;
                end; if not Enabled or CoreDestroyed then
                    CoruTask.Close("Galaxy ESP");
                end; Functions:GalaxyESP(); twait(0.1);
            end;
        end)

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "Dragon Adventures",
                Folder = "PlasmaGAG",
                Transparent = true,
                Theme = "Dark",
                SideBarWidth = 200,
                HasOutline = true,
                NewElements = true,
                OpenButton = {
                    Title = "Plasma Hub",
                    CornerRadius = UDim.new(1,0),
                    StrokeThickness = 3,
                    Enabled = true,
                    Draggable = true,
                    OnlyMobile = false,
                    Color = ColorSequence.new(Col3.fromHex("#30FF6A"), Col3.fromHex("#e7ff2f"))
                }, Topbar = {
                    Height = 44,
                    ButtonsType = "Mac",
                },
            });
            local Tabs = {
                Welcome = Window:Tab({Title="Welcome", Icon="smile"}),
                Client = LoaderSettings.AllowClientTab and Window:Tab({Title="Client", Icon="user"}),

                Div1 = Window:Divider(),
                Base = Window:Tab({Title="Base", Icon="house"}),
                Automation = Window:Tab({Title="Automation", Icon="cog"}),
                Events = Window:Tab({Title="Events", Icon="sparkles"}),

                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);
            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.Base, ScriptData.AutoData.BaseTab, "Base");
            Windy:CreateComponent(Tabs.Automation, ScriptData.AutoData.AutomationTab, "Automation");

            Windy:CreateComponent(Tabs.Events, ScriptData.AutoData.EventsTab, "Events");

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
                PromptPackage.UpdateState(true);
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function(AUTH_KEY)
            Storing_AUTHENTICATION = Storing_AUTHENTICATION or AUTH_KEY;
            if not Storing_AUTHENTICATION then return selff:Kick("Invalid Authentication 1PAC"); end;
            local Splited1 = str.split(Storing_AUTHENTICATION, "+++os()");
            local Splited2 = str.split(decrypt(Splited1[2], 3), "+++os()");
            local D1Auth = decrypt(Splited2[2], 3);
            local D2Auth = decrypt(Splited2[3], 2);
            D1Auth = D1Auth:gsub("emptyspace", "");
            D2Auth = D2Auth:gsub("emptyspace", "");
            if D1Auth == "200" then
                PremiumCheck = false;
            elseif D1Auth == "201" then
                PremiumCheck = true;
            else
                return selff:Kick("Invalid Authentication 2PAC");
            end; local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false; PromptPackage.UpdateState(false);
                ClientCon.WalkSpeed = HumSelf and HumSelf.WalkSpeed or 16;
                ClientCon.JumpPower = HumSelf and HumSelf.JumpPower or 50;
                GameData = GG.GameData or OriginalGameData;
                
                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if Functions:LAutoCon("Auto", false) or AutoCon.Mobs.Auto or AutoCon.Eggs.Auto or BaseCon.Sell.Auto then
                            CoruTask.Handle("GAutomation 1");
                        end;
                        if Functions:LAutoCon("ESP", false) or AutoCon.Treasures.ESP or AutoCon.Mobs.ESP or AutoCon.Eggs.ESP then
                            CoruTask.Handle("GESP 1");
                        end;
                        if AutoCon.Level.Riding then
                            CoruTask.Handle("Riding Leveling");
                        end;
                        if AutoCon.Guild.Coins then
                            CoruTask.Handle("Guild");
                        end;
                        
                        if GalaxyF then
                            local Enabled = false;
                            for _, v in pairs(GalaxyF.ESPPaths) do
                                if EventsCon.Galaxy[v] then
                                    Enabled = true;
                                    break;
                                end;
                            end; if EventsCon.Galaxy["Unlock Sections"] or EventsCon.Galaxy.AutoEggs or EventsCon.Galaxy.AutoMecha or EventsCon.Galaxy.AutoMeteorShower or EventsCon.Galaxy.AutoGreenCrate then
                                CoruTask.Handle("Galaxy");
                            end; if Enabled then
                                CoruTask.Handle("Galaxy ESP");
                            end;
                        end; twait(0.1);
                    end;
                end));

                CoreConnection[1] = H.Stepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[1] then
                        CoreConnection[1]:Disconnect(); CoreConnection[1] = nil;
                        return;
                    end;

                    Backpack = selff.Backpack;
                    selc = selff.Character;
                    HumSelf = selc and FindFirstChildOfClass(selc, "Humanoid");
                    HumRSelf = HumSelf and HumSelf.RootPart;
                    Seat = CommonF.GetSeat(HumSelf);

                    ClientPackage.UpdatePosition(ClientCon.Float, ForceFloat, HumRSelf);
                    ClientPackage.Noclip(ClientCon.Noclip, selc);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
                    ClientPackage.WalkSpeedC(ClientCon["Enable WalkSpeed"], ClientCon.WalkSpeed, HumSelf);
                    ClientPackage.JumpPower(ClientCon["Enable JumpPower"], ClientCon.JumpPower, HumSelf);
                end));
                CoreConnection[2] = H.Heartbeat:Connect(IB_NO_VIRTUALIZE(function(delta)
                    if CoreDestroyed and CoreConnection[2] then
                        CoreConnection[2]:Disconnect(); CoreConnection[2] = nil;
                        return;
                    end;

                    if ClientCon["Enable TeleportWalk"] and selc and HumSelf and HumSelf.MoveDirection.Magnitude > 0 then
                        selc:TranslateBy(HumSelf.MoveDirection * ClientCon["TeleportWalk Speed"] * delta * 10);
                    end;
                end));
                CoreConnection[3] = H.RenderStepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[3] then
                        CoreConnection[3]:Disconnect(); CoreConnection[3] = nil;
                        return;
                    end;

                    if AutoCon.Level.Bond then
                        Functions:Leveling("Bond");
                    end; if AutoCon.Level.Tracking then
                        Functions:Leveling("Track");
                    end;
                end));

                GG.UpdateGameData = Functions.UpdateGameData;

                if not CoruTask.Intialized then
                    local isSyncedF = Functions.isSynced;

                    Functions:SetSync();
                    Functions:IChestPos();
                    DAPackage:Init(WWorld);

                    if PlaceId == 5777228223 then
                        GalaxyF = DAPackage.GalaxyInit();
                        GalaxyF:Init(GInteractions, RRemotes);

                        Functions.MechaPos = CFr(744, -820, -84);
                        Functions.GALAXYBOSSZONE = CFr(-405, 149, -208);
                        Functions.SuperchargerKey = WaitForChild(SData.Resources, "SuperchargerKey", 9e9);
                        Functions.MeteSpawned = WaitForChild(GInteractions.EventGalaxy.MeteorShower, "Spawned", 9e9);
                        RE.GrabBatteryRemote = WaitForChild(RRemotes, "GrabBatteryRemote");
                    end;

                    if not isSyncedF() then
                        ScriptCache.WindUI:Notify({
                            Title = "<font color='rgb(255, 255, 0)'>Syncing</font>",
                            Content = "Script is waiting for game data to be synced. If the data is already synced; head to main tab and toggle 'Force Sync' to continue with this script.",
                            Icon = "circle-alert",
                            Duration = 20,
                        });
                        repeat twait(0.1); until isSyncedF();
                    end;

                    for i,v in pairs({
                        "Breaking Server Client Analytics.",
                        "Hooking Metric.FPS",
                        "Hooking Metric.Ping",
                        "Hooked Metric.Ping",
                        "Hooked Metric.FPS",
                        "Deleted AFKToolHandler",
                        "Deleted ClientHandler",
                        "Meta Hooking",
                        "Reversed OnClientInvoking",
                        "Hooked Mathematics",
                        "Your data is now synced by game or force synced";
                        "Set Memory Capcity",
                    }) do
                        WindUI:Notify({
                            Title = "<font color='rgb(118, 0, 255)'>WARNING</font>",
                            Content = v,
                            Icon = "circle-alert",
                            Duration = 20,
                        });
                    end;

                    CoruTask.Init(WindUI);
                    CoruTask.Intialized = true;

                    if UpperC then
                        local SuspiciusEvents = {
                            AFKEvent = true,
                            GameAnalyticsError = true,
                        };

                        local o = nil; o = GG.UpperC(game, "__namecall", newcclosure(function(self, ...)
                            if getnamecallmethod() == "FireServer" then
                                local selfN = tostring(self)
                                if selfN == "AFKEvent" or selfN == "GameAnalyticsError" then
                                    return wait(9e9);
                                elseif Configs.Client.Dragon.Godmode and (selfN == "DamageSelfRemote" or selfN == "MobDamageRemote") then
                                    return nil;
                                end;
                            end; return o(self , ...);
                        end));
                    end;

                    if LowerC then
                        local old; old = LowerC(require(R.Gamebeast.Infra.Shared.Modules.MetricCollector).ReportMetric, function(self, metric, value)
                            if metric == "PhysicsFps" then
                                local fakeFps;
                                if math.random() <= 0.10 then
                                    fakeFps = 58 + math.random() * 1.8;
                                else
                                    fakeFps = 60;
                                end; return old(self, metric, fakeFps)
                            end; return old(self, metric, value)
                        end);
                    end;

                    PSG.NodeGui.BoostFrame.ChildAdded:Connect(IB_NO_VIRTUALIZE(function(v)
                        if SystemStackDestroy or not Configs.Client.Client["Auto Click Minigame"] then return; end;
                        if IsA(v, "Frame") and FindFirstChild(v, "ClickButton") then
                            if getconnections then
                                twait(0.5); for i,v in next, getconnections(v.ClickShadowButton.MouseButton1Down) do
                                    v.Function();
                                end; return;
                            else
                                twait(0.5);
                                local button = v.ClickShadowButton;
                                local centerX = button.AbsolutePosition.X + (button.AbsoluteSize.X / 2);
                                local centerY = button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2);
                                VIM:SendMouseButtonEvent(centerX, centerY, 0, true, nil, 1);
                                VIM:SendMouseButtonEvent(centerX, centerY, 0, false, nil, 1);
                            end;
                        end;
                    end));

                    CoruTask.APC("if not in", Functions, {
                        5777228223
                    }, {
                        "GalaxyGetBattery", "GalaxyGetCrate",
                        "GalaxyUnlockChamber", "IsCarryingBattery",
                        "CollectBattery", "GalaxyEgg", "isMechaActivated",
                        "GalaxyMecha", "GalaxyShower", "GalaxyTeleport",
                        "GalaxyESP", "GalaxyGetGCrate", "GalaxyKeyCrate",
                    });
                    CoruTask.APC("if in", Functions, {
                        5777228223
                    }, {
                        "GetBase", "GetSEggs", "Incubate", "Hatch",
                        "GoToGeneralStore", "GetRRing", "GetGNest",
                        "GetGDrops", "IsNodeSafe", "IsPosSafe", "GetGNode",
                        "ValidateNodeState", "CollectNode", "ESPNodes",
                        "FireEgg", "CollectEgg", "ChestTps", "ESPChests",
                        "CollectGuildCoin", 
                    });
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};
