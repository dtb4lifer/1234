local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[Plasma Hub] : Really? Your account is now at risk for the next ban wave."); end;

local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local HttpService = GG.HttpService;
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
local P = GG.P;

local PlaceId = game.PlaceId;

local CFr = CF.new;
local IsA = game.IsA;
local twait = tk.wait;
local GetPivot = W.GetPivot;
local TwInfo = TweenInfo.new;
local GetPlayers = P.GetPlayers;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local FindFirstChild = game.FindFirstChild;
local GenerateGUID = HttpService.GenerateGUID;
local GetPlayerByUserId = P.GetPlayerByUserId;
local FindFirstChildOfClass = game.FindFirstChildOfClass;
local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA;
local FindFirstAncestorOfClass = game.FindFirstAncestorOfClass;

local LOWESTNUM = 0.000000032;

local RED = Col3.new(1,0,0);
local GREEN = Col3.new(0, 1, 0);
local BLUE = Col3.new(0, 0, 1);
local WHITE = Col3.new(1, 1, 1);

local EMPTYF = function() end;

local MUTCOLOR = {
    Gold = "#FFD700",
    Rainbow = "#FF69FF",
    Electric = "#00FFFF",
    Frozen = "#80DFFF",
    Starstruck = "#FFFACD",
    Bloodlit = "#AA0000",
    Chained = "#808080",
    Solarflare = "#FF6600",
    Pizza = "#FFCC66",
}

local ScriptData = {
    AutoData = {};
};

GG.Configs = GG.Configs or {
    ["Garden"] = {}; 
    ["Harvest"] = {
        ["SelectPlant"] = "Acorn";
        ["Schemas"] = {};
    };
    ["Sell"] = {
        ["SelectFruit"] = "Acorn";
        ["Schemas"] = {};
    };
    ["Shop"] = {
        ["Seeds"] = {};
        ["Gears"] = {};
        ["Pets"] = {};
    };
    ["Client"] = {
        ["Client"] = {
            ["FPSCap"] = 60;
            ["TeleportWalk Speed"] = 1;
        };
    };
    ["Events"] = {
        ["Seeds"] = {
            ["Gold"] = false;
            ["Rainbow"] = false;
        };
    };
};

GG.Configs.Events = GG.Configs.Events or {
    ["Seeds"] = {
        ["Gold"] = false;
        ["Rainbow"] = false;
    };
};
GG.Configs.Shop.Pets = GG.Configs.Shop.Pets or {};

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
    Version = "GAG2_V3.12_NOAUTH";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, CoruTask, ESPF, CommonF)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;
        local GalaxyF           = nil;

        local AllGardens        = nil;
        local AllProps          = nil;
        local GVC               = nil;
        local PVC               = nil;
        local TVC               = nil;
        local CurrentPage       = 0;
        local CurrentPage2      = 0;
        local PurchaseData      = nil;
        local Seat              = nil;
        local Cam               = W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local Backpack          = selff.Backpack;
        local PSG               = selff.PlayerGui;
        local selc              = selff.Character or selff.CharacterAdded:Wait();
        local HumSelf           = FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf.RootPart;
        local PSS               = selff.PlayerScripts;
        local Suid              = selff.UserId;

        local cmdm              = selff:GetMouse();
        local GardenCon         = GG.Configs.Garden;
        local HarvestCon        = GG.Configs.Harvest;
        local SellCon           = GG.Configs.Sell;
        local ShopCon           = GG.Configs.Shop;
        local EventsCon         = GG.Configs.Events;
        local ClientCon         = GG.Configs.Client.Client;
        local GPGuids           = {GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService)};
        local GTGuids           = {GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService)};

        local Map               = WaitForChild(W, "Map", 9e9);
        local SeedPackSpawn     = WaitForChild(Map, "SeedPackSpawnServerLocations", 9e9);

        local SharedData        = WaitForChild(R, "SharedData", 9e9);
        local SharedModules     = WaitForChild(R, "SharedModules", 9e9);
        local SController       = WaitForChild(PSS, "Controllers", 9e9); 

        local GSController      = require(WaitForChild(SController, "GardenSyncController", 9e9));
        local FVC               = require(WaitForChild(SController, "FruitVisualizerController", 9e9));
        local FruitValueCalc    = require(WaitForChild(SharedModules, "FruitValueCalc", 9e9));
        local Networking        = require(WaitForChild(SharedModules, "Networking", 9e9));
        local SeedData          = require(WaitForChild(SharedModules, "SeedData", 9e9));
        local PetData           = require(WaitForChild(SharedData, "PetData", 9e9));
        local GearData          = require(WaitForChild(SharedModules, "GearShopData", 9e9)).Data;
        local Mutations         = {"Gold", "Rainbow", "Electric", "Frozen", "Bloodlit", "Chained", "Starstruck"};

        local Garden            = WaitForChild(W, "Gardens", 9e9);
        local Plot              = WaitForChild(Garden, "Plot"..GetAttribute(selff, "PlotId"), 9e9);

        local dist              = CommonF.dist;
        
        local Functions         = {};
        local RE                = {
            SellAll             = Networking.NPCS.SellAll;
            CollectFruit        = Networking.Garden.CollectFruit;
            SellFruit           = Networking.NPCS.SellFruit;
            PurchaseSeed        = Networking.SeedShop.PurchaseSeed;
            PurchaseGear        = Networking.GearShop.PurchaseGear;
            BeginSteal          = Networking.Steal.BeginSteal;
            CompleteSteal       = Networking.Steal.CompleteSteal;
            WildPetTame         = Networking.Pets.WildPetTame;
        };

        local function ColorMutation(Mutation)
            local Color = MUTCOLOR[Mutation];
            if Color then
                return string.format(
                    '<font color="%s">%s</font>',
                    Color,
                    Mutation
                );
            end; return tostring(Mutation or "None");
        end;
        local function FormatEntry(Entry)
            local Price = Entry.Price;
            local PriceText = tostring(Price);
            if Price >= 5000 then
                PriceText = str.format(
                    '<font color="#FF4444">%s</font>',
                    PriceText
                );
            end;
            local Title = str.format(
                "%s [$%s]",
                Entry.PlantName or "Unknown",
                PriceText
            );
            local Desc = str.format(
                "Mutation: %s, Weight: %.2fkg\nAge: %s/%s",
                ColorMutation(Entry.Mutation),
                tonumber(Entry.Weight) or 0,
                tostring(Entry.Age),
                tostring(Entry.MaxAge)
            ); return Title, Desc;
        end;
        local function UpdateDesc(btn, ESP, Destroyed)
            btn:SetDesc(str.format(
                'ESP: <font color="%s">%s</font> ; Destroyed: <font color="%s">%s</font>',
                ESP and "#00FF00" or "#FF0000",
                ESP and "Enabled" or "Disabled",
                Destroyed and "#00FF00" or "#FF0000",
                Destroyed and "Yes" or "No"
            ));
        end;

        Functions.PairData = function(tab, goal, values)
            local tblx = {{type="Group", dats={
                {dat={}, Title=goal}
            }}, {type="Space"}, {type="Space"}};

            if goal == "Seeds" then
                for i=1, #values do
                    local v=values[i]; if type(v) ~= "table" or not v.PurchasePrice or not v.RestockShop then
                        continue;
                    end;

                    local Price = tostring(v.PurchasePrice);
                    tble.insert(tblx[1].dats[1].dat, {
                        type="Toggle";
                        EN=v.SeedName;
                        EN2="Cost: "..Price;
                        TH1=v.SeedName;
                        TH2="à¸£à¸²à¸„à¸²: "..Price;
                        Path=goal.."/"..v.SeedName;
                    })
                end
            elseif goal == "Gears" then
                for i=1, #values do
                    local v=values[i]; if type(v) ~= "table" or not v.RestockChance or not v.Cost or not v.ItemName or not v.ItemType then
                        continue;
                    end;

                    local Price = tostring(v.Cost);
                    tble.insert(tblx[1].dats[1].dat, {
                        type="Toggle";
                        EN=v.ItemName;
                        EN2="Cost: "..Price;
                        TH1=v.ItemName;
                        TH2="à¸£à¸²à¸„à¸²: "..Price;
                        Path=goal.."/"..v.ItemName;
                    })
                end;
            elseif goal == "Pets" then
                for i,v in pairs(values) do
                    if type(v) ~= 'table' then continue; end;
                    local Price = tostring(v.BasePrice);
                    tble.insert(tblx[1].dats[1].dat, {
                        type="Toggle";
                        EN=i;
                        EN2="Cost: "..Price;
                        TH1=i;
                        TH2="à¸£à¸²à¸„à¸²: "..Price;
                        Path=goal.."/"..i;
                    });
                end;
            end;

            return Windy:CreateComponent(tab, tblx, "Shop");
        end;
        Functions.PairHarvest = IB_NO_VIRTUALIZE(function(i, ina)
            local TargetSeed = i or HarvestCon.SelectPlant;
            if not TargetSeed then return; end;

            local GUIDs = {GenerateGUID(HttpService), GenerateGUID(HttpService)};
            local Schema = ina or {
                Mutations = {};
                Weight = nil;
            };
            
            local RWeight = nil;
            if Schema.Weight then
                RWeight = str.format("%s-%s", tostring(Schema.Weight.MinWeight or ""), tostring(Schema.Weight.MaxWeight or ""));
            else
                RWeight = "";
            end;

            Windy:CreateComponent(ScriptCache.HarvestTab, {
                {type="Group", dats={
                    {dat={
                        {type="Space"}; {type="Dropdown", Title="Select Mutation", TH1="à¹€à¸¥à¸·à¸­à¸ Mutation", Multi=true, AllowNone=true, Value=Schema.Mutations, Values=Mutations, Callback=function(...)
                            Schema.Mutations = ...;
                        end};
                        {type="Input", Title="Weight Pool", TH1="à¸Šà¹ˆà¸§à¸‡à¸™à¹‰à¸³à¸«à¸™à¸±à¸", Placeholder="Ex. 100-2000", Value=RWeight, Callback=function(val)
                            local Split = str.split(val, "-");
                            if #Split == 2 then
                                local Min = tonumber(Split[1]);
                                local Max = tonumber(Split[2]);
                                Schema.Weight = {MinWeight=Min, MaxWeight=Max};
                                return;
                            end; Schema.Weight = nil;
                        end};
                        {type="Button", Title="Delete This Schema", TH1="à¸¥à¸šà¸•à¸²à¸£à¸²à¸‡à¸™à¸µà¹‰", Callback=function()
                            tble.remove(HarvestCon.Schemas[TargetSeed], tble.find(HarvestCon.Schemas[TargetSeed], Schema));
                            ScriptCache[Schema].ElementFrame.Parent:Destroy();
                            ScriptCache[GUIDs[1]].ElementFrame:Destroy();
                            ScriptCache[GUIDs[2]].ElementFrame:Destroy();
                        end}; {type="Space"};
                    }, Title=TargetSeed, Global=Schema};
                }}; {type="Space", Global=GUIDs[1]}; {type="Space", Global=GUIDs[2]};
            }, "Harvest");

            if not ina then
                HarvestCon.Schemas[TargetSeed] = HarvestCon.Schemas[TargetSeed] or {};
                tble.insert(HarvestCon.Schemas[TargetSeed], Schema);
            end;
        end);
        Functions.PairSell = IB_NO_VIRTUALIZE(function(i, ina)
            local TargetSeed = i or SellCon.SelectFruit;
            if not TargetSeed then return; end;
            
            local GUIDs = {GenerateGUID(HttpService), GenerateGUID(HttpService)};
            local Schema = ina or {
                Price = nil;
            };

            local RPrice = nil;
            if Schema.Price then
                RPrice = str.format("%s-%s", tostring(Schema.Price.MinPrice or ""), tostring(Schema.Price.MaxPrice or ""));
            else
                RPrice = "";
            end;

            Windy:CreateComponent(ScriptCache.SellTab, {
                {type="Group", dats={
                    {dat={
                        {type="Input", Title="Price", TH1="à¸Šà¹ˆà¸§à¸‡à¸£à¸²à¸„à¸²", Placeholder="Ex. 100-2000", Value=RPrice, Callback=function(val)
                            local Split = str.split(val, "-");
                            if #Split == 2 then
                                local Min = tonumber(Split[1]);
                                local Max = tonumber(Split[2]);
                                Schema.Price = {MinPrice=Min, MaxPrice=Max};
                                return;
                            end; Schema.Price = nil;
                        end};
                        {type="Button", Title="Delete This Schema", TH1="à¸¥à¸šà¸•à¸²à¸£à¸²à¸‡à¸™à¸µà¹‰", Callback=function()
                            tble.remove(SellCon.Schemas[TargetSeed], tble.find(SellCon.Schemas[TargetSeed], Schema));
                            ScriptCache[Schema].ElementFrame.Parent:Destroy();
                            ScriptCache[GUIDs[1]].ElementFrame:Destroy();
                            ScriptCache[GUIDs[2]].ElementFrame:Destroy();
                        end}; {type="Space"};
                    }, Title=TargetSeed, Global=Schema};
                }}; {type="Space", Global=GUIDs[1]}; {type="Space", Global=GUIDs[2]};
            }, "Sell");

            if not ina then
                SellCon.Schemas[TargetSeed] = SellCon.Schemas[TargetSeed] or {};
                tble.insert(SellCon.Schemas[TargetSeed], Schema);
            end;
        end);
        Functions.GRebuild = function(self, Plants, isPrice, isWeight, uid)
            local Sorted = {}; for i, Data in pairs(Plants) do
                if self.IsOnlyOne(Data) then
                    local Price = isPrice and FruitValueCalc(Data.PlantName, Data.SizeMultiplier, Data.Mutation, selff, false);
                    local Weight = isWeight and Data.Weight;
                    Sorted[#Sorted + 1] = {
                        Weight = if isWeight then Weight else nil;
                        Price = if isPrice then Price else nil;
                        PlantName = Data.PlantName;
                        Mutation = Data.Mutation;
                        MaxAge = Data.MaxAge;
                        Age = Data.Age;
                        PlantId = i;
                    };
                else
                    for fid, fd in pairs(Data.Fruits) do
                        local Price = isPrice and FruitValueCalc(Data.PlantName, fd.SizeMultiplier, fd.Mutation, selff, false);
                        Sorted[#Sorted + 1] = {
                            Price = if isPrice then Price else nil;
                            PlantName = Data.PlantName;
                            Mutation = fd.Mutation;
                            MaxAge = fd.MaxAge;
                            Age = fd.Age;
                            FruitId = fid;
                            PlantId = i;
                        };

                        if isWeight then
                            local Select = Sorted[#Sorted];
                            local Obj = self:GetFruit(Select, uid);
                            if not Obj then
                                Sorted[#Sorted]=nil;
                                continue;
                            end;
                            local Weight = FVC:CalculateFruitWeight(Obj);
                            Select.Obj = Obj;
                            Select.Weight = Weight;
                        end;
                    end;
                end;
            end; if isPrice then
                tble.sort(Sorted, function(a, b)
                    return a.Price > b.Price;
                end);
            end; return Sorted;
        end;
        Functions.PRebuild = function(self, Props, isTrap)
            local Sorted = {}; for i, Data in pairs(Props) do
                Sorted[#Sorted + 1] = {
                    PropId = i;
                    Name = Data.PropName;
                };
            end; tble.sort(Sorted, function(a, b)
                local aTrap = str.find(a.Name, "Trap", 1, true) ~= nil;
                local bTrap = str.find(b.Name, "Trap", 1, true) ~= nil;
                if aTrap ~= bTrap then
                    return aTrap;
                end; return a.Name < b.Name;
            end); return Sorted;
        end;
        Functions.GetSortPage = function(Sorted, Page)
            local Start = ((Page - 1) * 10) + 1;
            local End = math.min(Start + 9, #Sorted);
            local Result = {};
            for i = Start, End do
                Result[#Result + 1] = Sorted[i]
            end; return Result;
        end;
        Functions.PairGarden = function(useCache)
            local TargetPlayer = GardenCon["Select Player"];
            TargetPlayer = TargetPlayer and FindFirstChild(P, TargetPlayer);
            if not TargetPlayer then return; end;
            local self, Plants, Rebuild = Functions, nil, nil;

            if not useCache then
                Plants = self.GetGarden(TargetPlayer);
                Rebuild = self:GRebuild(Plants, true, true, TargetPlayer.UserId);
            else
                Rebuild = ScriptCache.Rebuilt;
            end;

            CurrentPage = math.clamp(CurrentPage, 1, math.max(1, math.ceil(#Rebuild / 10)));

            local PageData = Functions.GetSortPage(Rebuild, CurrentPage);
            if #PageData == 0 then return; end;

            tk.defer(function()
                for i=1, #GPGuids do
                    local btn = ScriptCache[GPGuids[i]];
                    local LastClick, Data = 0, PageData[i];
                    if Data then
                        local Title, Desc = FormatEntry(Data);
                        btn:SetTitle(Title); btn:SetDesc(Desc);
                        btn.Callback = function()
                            local Fruit, IsOne = Data.Obj or self:GetFruit(Data, TargetPlayer.UserId);
                            if not Fruit then return; end; if LastClick > tick() then
                                if TargetPlayer ~= selff then
                                    Functions.StealAFruit(Fruit, Data.PlantId, IsOne and "" or Data.FruitId, TargetPlayer.UserId);
                                else
                                    RE.CollectFruit:Fire(Data.PlantId, IsOne and "" or Data.FruitId);
                                    WindUI:Notify({
                                        Title = "<font color='rgb(0, 255, 0)'>Success</font>",
                                        Content = Title,
                                        Icon = "circle-alert",
                                        Duration = 5,
                                    });
                                end;
                            end;
                            Functions.LocalTp(HumRSelf, GetPivot(Fruit), 0);
                            LastClick = tick() + 1;
                        end;
                    else
                        btn:SetTitle("-"); btn:SetDesc("-"); btn.Callback = EMPTYF;
                    end;
                end;
            end);

            ScriptCache.Rebuilt = Rebuild;

            self.PairTraps();
        end;
        Functions.PairTraps = function(useCache)
            local TargetPlayer = GardenCon["Select Player"];
            TargetPlayer = TargetPlayer and FindFirstChild(P, TargetPlayer);
            if not TargetPlayer then return; end;
            local self, Props, Rebuild = Functions, nil, nil;

            if not useCache then
                Props = self.GetProps(TargetPlayer);
                Rebuild = self:PRebuild(Props);
            else
                Rebuild = ScriptCache.PRebuilt;
            end;

            CurrentPage2 = math.clamp(CurrentPage2, 1, math.max(1, math.ceil(#Rebuild / 10)));

            local PageData = Functions.GetSortPage(Rebuild, CurrentPage2);
            if #PageData == 0 then return; end;

            tk.defer(function()
                for i=1, #GTGuids do
                    local btn = ScriptCache[GTGuids[i]];
                    local LastClick, Data = 0, PageData[i];
                    local Highlight = nil;
                    if Data then
                        local ESP, Destroyed = false, false;
                        UpdateDesc(btn, ESP, Destroyed);

                        btn:SetTitle(Data.Name); btn.Callback = function()
                            local Object = TVC:GetSpawnedProp(TargetPlayer.UserId, Data.PropId);
                            local Now = os.clock();
                            if Object and Now - LastClick < 0.3 then
                                Object:Destroy();
                                Destroyed = true;
                                return UpdateDesc(btn, ESP, Destroyed);
                            end;

                            LastClick = Now;
                            ESP = not ESP;

                            if ESP and Object then
                                Highlight = Instance.new("Highlight", Object);
                                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                Highlight.FillColor = RED;
                                Highlight.Enabled = true;
                            elseif Highlight then
                                Highlight:Destroy();
                            end;

                            UpdateDesc(btn, ESP, Destroyed);
                        end;
                    else
                        btn:SetTitle("-"); btn:SetDesc("-"); btn.Callback = EMPTYF;
                    end;
                end;
            end);

            ScriptCache.PRebuilt = Rebuild;
        end;
        Functions.LocalTp = function(HumRSelf, cf, time)
            if not HumRSelf then return; end;
            for i=1, 50 do
                HumRSelf.CFrame = cf; wait(time);
            end;
        end;
        Functions.GetGarden = function(target)
            return AllGardens[target.UserId];
        end
        Functions.GetProps = function(target)
            return AllProps[target.UserId];
        end;
        Functions.IsOnlyOne = function(data)
            return if not data.MaxFruitSpawnLocations or data.MaxFruitSpawnLocations <= 0 then true else false;
        end;
        Functions.GetPlot = function(uid)
            local TPlot = if uid == Suid then Plot else nil;
            if TPlot then return TPlot end;
            local pl = GetPlayerByUserId(P, uid); 
            local plot = pl and GetAttribute(pl, "PlotId");
            if not pl then return; end;
            TPlot = FindFirstChild(Garden, "Plot"..plot);
            return TPlot;
        end;
        Functions.GetFruit = function(self, data, uid)
            if not self.IsOnlyOne(data) or data.FruitId then
                local Obj = data.PlantId and data.FruitId and FVC:GetSpawnedFruit(uid, data.PlantId, data.FruitId);
                if not Obj then
                    local TPlot = self.GetPlot(uid);
                    if not TPlot then return; end;
                    Obj = FindFirstChild(TPlot.Plants[uid .. "_" .. data.PlantId].Fruits, uid .. "_" .. data.PlantId .. "_" .. data.FruitId);
                end; return Obj, false;
            end; return data.PlantId and PVC:GetSpawnedPlant(uid, data.PlantId), true;
        end;
        Functions.ShouldHarvest = function(plantid, fruitid, data, HarvestSH)
            local Object=nil; if fruitid then
                Object = FVC:GetSpawnedFruit(Suid, plantid, fruitid);
            else
                Object = PVC and PVC:GetSpawnedPlant(Suid, plantid) or nil;
            end;

            local Age, MaxAge = data.Age, data.MaxAge;
            if Object then
                local objAge = Object:GetAttribute("Age");
                if objAge then Age = objAge; end;
            end;

            if Age and MaxAge and Age < MaxAge then return false; end;

            local Mutation = data.Mutation;
            local Weight = data.Weight;

            if not Weight then
                if not Object then return false; end;
                if fruitid then
                    Weight = FVC:CalculateFruitWeight(Object);
                else
                    Weight = FVC and FVC.CalculatePlantWeight and FVC:CalculatePlantWeight(Object) or 0;
                end;
            end;

            for i=1, #HarvestSH do
                local Schema = HarvestSH[i]; if not Schema then continue; end;
                local Passed = true; if #Schema.Mutations > 0 then
                    if not tble.find(Schema.Mutations, Mutation) then
                        Passed = false;
                    end;
                end;

                if Passed and Schema.Weight then
                    local Min = Schema.Weight.MinWeight;
                    local Max = Schema.Weight.MaxWeight;
                    if Min and Max and Weight then
                        if Weight < Min or Weight > Max then
                            Passed = false;
                        end;
                    end;
                end; if Passed then
                    return true;
                end;
            end;
        end;
        Functions.Harvest = function(self)
            local Plants = self.GetGarden(selff);
            for i,v in pairs(Plants) do
                if not HarvestCon.Auto then return; end;
                if v then
                    local HarvestSH = HarvestCon.Schemas[v.PlantName];
                    if not HarvestSH or #HarvestSH <= 0 then continue; end;

                    local OnlyOne = self.IsOnlyOne(v);
                    
                    if not OnlyOne then
                        for f,j in pairs(v.Fruits) do
                            if self.ShouldHarvest(i, f, j, HarvestSH) then
                                RE.CollectFruit:Fire(i, f); H.RenderStepped:Wait();
                            end;
                        end;
                    elseif self.ShouldHarvest(i, nil, v, HarvestSH) then
                        RE.CollectFruit:Fire(i, "");
                    end;
                end;
            end;
        end;
        Functions.ShouldSell = function(v)
            local Fruit = GetAttribute(v, "FruitName");
            if not Fruit then return false; end;

            local TargetSC = SellCon.Schemas[Fruit];
            if not TargetSC or #TargetSC <= 0 then return false; end;

            local Mut = GetAttribute(v, "Mutation");
            local SizeMulti = GetAttribute(v, "SizeMultiplier");
            local Value = FruitValueCalc(
                Fruit,
                SizeMulti,
                Mut,
                selff,
                false
            );

            for i = 1, #TargetSC do
                local Schema = TargetSC[i];
                if not Schema.Price then continue; end;
                local Min = Schema.Price.MinPrice or 0;
                local Max = Schema.Price.MaxPrice or 999999;
                if Min and Max then
                    if Value >= Min and Value <= Max then
                        return true;
                    end;
                end;
            end; return false;
        end;
        Functions.Sell = function(self)
            if SellCon.SellAll then
                return RE.SellAll:Fire();
            end;

            local Inv = GetChildren(Backpack); for i=1, #Inv do
                if not SellCon.Auto then return; end;
                local v = Inv[i]; if v then
                    if not GetAttribute(v, "IsFavorite") then
                        if self.ShouldSell(v) then
                            RE.SellFruit:Fire(GetAttribute(v, "Id"));
                        end;
                    end;
                end;
            end;
        end;
        Functions.StealAFruit = function(Obj, pid, fid, uid)
            if not Obj then return; end;
            local Pivot = GetPivot(Obj);
            local Home = Plot.Visual.PRIM.CFrame;
            Functions.LocalTp(HumRSelf, Pivot, 0);
            RE.BeginSteal:Fire(uid, pid, fid or "");
            twait(Obj.HarvestPart.StealPrompt.HoldDuration);
            RE.CompleteSteal:Fire();
            Functions.LocalTp(HumRSelf, Home, 0);
        end;
        Functions.ShopSeed = IB_NO_VIRTUALIZE(function()
            if not PurchaseData then return; end;
            for i,v in pairs(ShopCon.Seeds) do
                if v then
                    local Item = FindFirstChild(R.StockValues.SeedShop.Items, i);
                    if Item and Item.Value then
                        local Bought = PurchaseData.Seeds[i] or 0;
                        while Bought < Item.Value do
                            RE.PurchaseSeed:Fire(i);
                            Bought += 1;
                            twait(0.1);
                        end;
                    end;
                end;
            end;
        end);
        Functions.ShopGear = IB_NO_VIRTUALIZE(function()
            if not PurchaseData then return; end;
            for i,v in pairs(ShopCon.Gears) do
                if v then
                    local Item = FindFirstChild(R.StockValues.GearShop.Items, i);
                    if Item and Item.Value then
                        local Bought = PurchaseData.Gears[i] or 0;
                        while Bought < Item.Value do
                            RE.PurchaseGear:Fire(i);
                            Bought += 1;
                            twait(0.1);
                        end;
                    end;
                end;
            end;
        end);
        Functions.ShopPet = IB_NO_VIRTUALIZE(function(self)
            local Childs = GetChildren(W.Map.WildPetRef);
            for i=1, #Childs do
                local v=Childs[i]; if v and v.Parent then
                    local Price = GetAttribute(v, "Price"); if Price and Price >= selff.leaderstats.Sheckles.Value then continue; end;
                    if GetAttribute(v, "OwnerName") ~= selff.Name and ShopCon.Pets[GetAttribute(v, "PetName")] then
                        self.LocalTp(HumRSelf, v.CFrame, 0);
                        RE.WildPetTame:Fire(v);
                        twait(0.1);
                    end;
                end;
            end;
        end);
        Functions.AutoCollectSeeds = IB_NO_VIRTUALIZE(function(self)
            local SeedPacks = GetChildren(SeedPackSpawn);
            local WantGold = EventsCon.Seeds.Gold;
            local WantRainbow = EventsCon.Seeds.Rainbow;
            for i = 1, #SeedPacks do
                local v = SeedPacks[i]; if v and v.Parent then
                    local Match = (WantGold and GetAttribute(v, "GoldSeed")) or (WantRainbow and GetAttribute(v, "RainbowSeed"));
                    if Match then
                        local Prompt = FindFirstChild(v, "ProximityPrompt");
                        self.LocalTp(HumRSelf, v.CFrame, 0);
                        fireproximityprompt(Prompt);
                    end;
                end;
            end;
        end);

        ScriptData.AutoData = {
            ClientTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Go Underground", EN2="Temporary remove the floor", TH1="à¸¥à¸‡à¹ƒà¸•à¹‰à¸”à¸´à¸™", TH2="à¹€à¸­à¸²à¸žà¸·à¹‰à¸™à¸­à¸­à¸à¸Šà¸±à¹ˆà¸§à¸„à¸£à¸²à¸§", Bindable="+", Path="Client/GoUnderground", Callback=function(state)
                            ClientCon.GoUnderground = state;
                            W.Baseplate.TopLayer.CanCollide = not state;
                        end},
                        {type="Toggle", EN="No Render", EN2="Disable Roblox's rendering.", TH1="à¸›à¸´à¸” Render", TH2="à¸ˆà¸­à¸‚à¸²à¸§", Path="Client/NoRender", Callback=function(state)
                            ClientCon.NoRender = state;
                            H:Set3dRenderingEnabled(not state);
                        end},
                        {type="Slider", EN="FPS Cap", EN2="Limit your FPS.", TH1="à¸ˆà¸³à¸à¸±à¸” FPS", TH2="à¸›à¸£à¸°à¸«à¸¢à¸±à¸”à¸žà¸¥à¸±à¸‡à¸‡à¸²à¸™à¹à¸¥à¸°à¸žà¸·à¹‰à¸™à¸—à¸µà¹ˆà¹€à¸„à¸£à¸·à¹ˆà¸­à¸‡", Value={Min=1, Max=300}, Path="Client/FPSCap", Callback=function(value)
                            ClientCon.FPSCap = value;
                            setfpscap(tonumber(value));
                        end},
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="à¹à¸¡à¸žà¸ªà¸§à¹ˆà¸²à¸‡", TH2="à¸¡à¸­à¸‡à¹€à¸«à¹‡à¸™à¸‡à¹ˆà¸²à¸¢à¸‚à¸¶à¹‰à¸™", Path="Client/Full Bright"},
                        {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="à¹€à¸”à¸´à¸™à¸—à¸°à¸¥à¸¸à¸à¸³à¹à¸žà¸‡", TH2="à¸•à¹‰à¸­à¸‡à¸­à¸˜à¸´à¸šà¸²à¸¢à¸”à¹‰à¸§à¸¢à¸«à¸£à¸­", Path="Client/Noclip"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="à¸„à¸§à¸²à¸¡à¹€à¸£à¹‡à¸§à¹ƒà¸™à¸à¸²à¸£à¹€à¸”à¸´à¸™à¹à¸šà¸šà¸§à¸²à¸£à¹Œà¸›", TH2="à¸›à¸£à¸±à¸šà¸„à¸§à¸²à¸¡à¹€à¸£à¹‡à¸§à¹ƒà¸™à¸à¸²à¸£à¹€à¸”à¸´à¸™à¹à¸šà¸šà¸§à¸²à¸£à¹Œà¸›", Value={Min=0, Max=2}, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™à¹€à¸”à¸´à¸™à¹à¸šà¸šà¸§à¸²à¸£à¹Œà¸›", TH2="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™à¹€à¸”à¸´à¸™à¹‚à¸”à¸¢à¸à¸²à¸£à¸§à¸²à¸£à¹Œà¸›à¹„à¸›à¹€à¸£à¸·à¹ˆà¸­à¸¢à¹†", Path="Client/Enable TeleportWalk"},
                    }, Title="Client", Open=true};
                }};
            };
            GardenTab = {
                {type="Toggle", EN="Player Nearby", EN2="Send notification when someone is near your garden.", TH1="à¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™à¹€à¸‚à¹‰à¸²à¹ƒà¸à¸¥à¹‰", TH2="à¹à¸ˆà¹‰à¸‡à¹€à¸•à¸·à¸­à¸™à¹€à¸§à¸¥à¸²à¸¡à¸²à¸„à¸™à¹€à¸‚à¹‰à¸²à¸¡à¸²à¹ƒà¸à¸¥à¹‰", Path="Notify"}, {type="Space"}, {type="Space"},
                {type="Dropdown", Title="Select Player", TH1="à¹€à¸¥à¸·à¸­à¸à¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™", AllowNone=true, Values={}, Path="Select Player", RECall={
                    Title = "Refresh Players",
                    RECall = function()
                        local Players, tbl = GetPlayers(P), {};
                        for i=1, #Players do
                            tble.insert(tbl, Players[i].Name);
                        end; return tbl;
                    end;
                }},
                {type="Button", EN="Get Garden Info", EN2="Show player's best fruit and their garden informations.",TH1="à¸£à¸±à¸šà¸‚à¹‰à¸­à¸¡à¸¹à¸¥à¸ªà¸§à¸™",TH2="à¹à¸ªà¸”à¸‡à¸‚à¹‰à¸­à¸¡à¸¹à¸¥à¸ªà¸§à¸™à¸‚à¸­à¸‡à¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™à¸„à¸™à¸™à¸±à¹‰à¸™", Callback=Functions.PairGarden}, {type="Space"}, {type="Space"},
                {type="Group", dats={
                    {dat={
                        {type="Button", Title="-", Desc="-", Global=GPGuids[1]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[2]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[3]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[4]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[5]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[6]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[7]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[8]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[9]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[10]};
                        {type="Button", Title="Previous Page", Callback=function()
                            CurrentPage = CurrentPage - 1;
                            CurrentPage = if CurrentPage < 1 then CurrentPage else CurrentPage;
                            Functions.PairGarden(true);
                        end};
                        {type="Button", Title="Next Page", Callback=function()
                            CurrentPage = CurrentPage + 1;
                            Functions.PairGarden(true);
                        end};
                    }, Title="Plant/Fruit Data", Global="PFD"},
                }}, {type="Space"}, {type="Space"},
                {type="Group", dats={
                    {dat={
                        {type="Button", Title="-", Desc="-", Global=GTGuids[1]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[2]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[3]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[4]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[5]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[6]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[7]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[8]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[9]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[10]};
                        {type="Button", Title="Previous Page", Callback=function()
                            CurrentPage2 = CurrentPage2 - 1;
                            CurrentPage2 = if CurrentPage2 < 1 then CurrentPage2 else CurrentPage2;
                            Functions.PairTraps(true);
                        end};
                        {type="Button", Title="Next Page", Callback=function()
                            CurrentPage2 = CurrentPage2 + 1;
                            Functions.PairTraps(true);
                        end};
                    }, Title="Traps/Props", Global="TPD"},
                }},
            };
            HarvestTab = {
                {type="Dropdown", EN="Select Plant", EN2="Select plant to add to schema", TH1="à¹€à¸¥à¸·à¸­à¸à¸œà¸¥à¹„à¸¡à¹‰", TH2="à¹€à¸¥à¸·à¸­à¸à¸œà¸¥à¹„à¸¡à¹‰à¸—à¸µà¹ˆà¸ˆà¸°à¹€à¸žà¸´à¹ˆà¸¡à¸¥à¸‡à¹ƒà¸™ Schema", AllowNone=true, Values=(function()
                    local tbl, NewS={}, tble.clone(SeedData);
                    tble.sort(NewS, function(a,b)
                        return str.lower(a.SeedName) < str.lower(b.SeedName)
                    end); for i=1, #NewS do
                        if type(NewS[i]) == "table" and NewS[i].SeedName then
                            tble.insert(tbl, NewS[i].SeedName);
                        end;
                    end; return tbl;
                end)(), Path="SelectPlant"},
                {type="Button", EN="Add Schema", EN2="Add schema to auto harvest", TH1="à¹€à¸žà¸´à¹ˆà¸¡", TH2="à¹€à¸žà¸´à¹ˆà¸¡ Schema", Callback=Functions.PairHarvest};
                {type="Toggle", EN="Auto Harvest", EN2="Auto harvest selected plant using long distance harvesting.", TH1="à¸­à¸­à¹‚à¸•à¹‰à¹€à¸à¹‡à¸šà¸œà¸¥à¹„à¸¡à¹‰", TH2="à¸­à¸­à¹‚à¸•à¹‰à¹€à¸à¹‡à¸šà¸œà¸¥à¹„à¸¡à¹‰à¸—à¸µà¹ˆà¹€à¸¥à¸·à¸­à¸à¹à¸šà¸šà¸£à¸°à¸¢à¸°à¹„à¸à¸¥", Path="Auto"}, {type="Space"}, {type="Space"},
            };
            SellTab = {
                {type="Dropdown", EN="Select fruit", EN2="Select fruit to add to schema", TH1="à¹€à¸¥à¸·à¸­à¸à¸œà¸¥à¹„à¸¡à¹‰", TH2="à¹€à¸¥à¸·à¸­à¸à¸œà¸¥à¹„à¸¡à¹‰à¸—à¸µà¹ˆà¸ˆà¸°à¹€à¸žà¸´à¹ˆà¸¡à¸¥à¸‡à¹ƒà¸™ Schema", AllowNone=true, Values=(function()
                    local tbl, NewS={}, tble.clone(SeedData);
                    tble.sort(NewS, function(a,b)
                        return str.lower(a.SeedName) < str.lower(b.SeedName)
                    end); for i=1, #NewS do
                        if type(NewS[i]) == "table" and NewS[i].SeedName then
                            tble.insert(tbl, NewS[i].SeedName);
                        end;
                    end; return tbl;
                end)(), Path="SelectFruit"},
                {type="Button", EN="Add Schema", EN2="Add schema to auto harvest", TH1="à¹€à¸žà¸´à¹ˆà¸¡", TH2="à¹€à¸žà¸´à¹ˆà¸¡ Schema", Callback=Functions.PairSell};
                {type="Toggle", EN="Use Sell All", EN2="This will make Auto Sell sell all fruits", TH1="à¸‚à¸²à¸¢à¸—à¸±à¹‰à¸‡à¸«à¸¡à¸”", TH2="à¸‚à¸²à¸¢à¸œà¸¥à¹„à¸¡à¹‰à¸—à¸±à¹‰à¸‡à¸«à¸¡à¸”à¸•à¸­à¸™à¹€à¸›à¸´à¸” à¸­à¸­à¹‚à¸•à¹‰à¸‚à¸²à¸¢", Path="SellAll"},
                {type="Toggle", EN="Auto Sell", EN2="Auto sell selected fruit using long distance selling.", TH1="à¸­à¸­à¹‚à¸•à¹‰à¸‚à¸²à¸¢à¸œà¸¥à¹„à¸¡à¹‰", TH2="à¸­à¸­à¹‚à¸•à¹‰à¸‚à¸²à¸¢à¸œà¸¥à¹„à¸¡à¹‰à¸—à¸µà¹ˆà¹€à¸¥à¸·à¸­à¸à¹à¸šà¸šà¸£à¸°à¸¢à¸°à¹„à¸à¸¥", Path="Auto"}, {type="Space"}, {type="Space"},
            };
            ShopTab = {
                {type="Toggle", EN="Auto Expand Area", EN2="Auto buy 'Expand Area' to expand the garden area.", TH1="à¸­à¸­à¹‚à¸•à¹‰à¸‚à¸¢à¸²à¸¢à¸žà¸·à¹‰à¸™à¸—à¸µà¹ˆ", TH2="à¸­à¸­à¹‚à¸•à¹‰à¸‹à¸·à¹‰à¸­ 'à¸‚à¸¢à¸²à¸¢à¸žà¸·à¹‰à¸™à¸—à¸µà¹ˆ' à¹€à¸žà¸·à¹ˆà¸­à¸‚à¸¢à¸²à¸¢à¸žà¸·à¹‰à¸™à¸—à¸µà¹ˆà¹ƒà¸™à¸ªà¸§à¸™", Path="Shop/AutoExpandArea"}, {type="Space"},
            };
            EventsTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Gold Seed", EN2="Teleport & collect gold seeds", TH1="à¹€à¸¡à¸¥à¹‡à¸”à¸—à¸­à¸‡", TH2="à¸§à¸²à¸›à¹€à¸à¹‡à¸šà¹€à¸¡à¸¥à¹‡à¸”à¸—à¸­à¸‡", Path="Seeds/Gold"},
                        {type="Toggle", EN="Rainbow Seed", EN2="Teleport & collect rainbow seeds.", TH1="à¹€à¸¡à¸¥à¹‡à¸”à¸£à¸¸à¹‰à¸‡", TH2="à¸§à¸²à¸›à¹€à¸à¹‡à¸šà¹€à¸¡à¸¥à¹‡à¸”à¸£à¸¸à¹‰à¸‡", Path="Seeds/Rainbow"},
                    }, Title="Seeds"};
                }};
            };
        };

        CoruTask.New("Harvest", function()
            while true do
                if not HarvestCon.Auto or CoreDestroyed then
                    CoruTask.Close("Harvest");
                end; Functions:Harvest();
                twait();
            end;
        end);
        CoruTask.New("Sell", function()
            while true do
                if not SellCon.Auto or CoreDestroyed then
                    CoruTask.Close("Sell");
                end; Functions:Sell();
                twait();
            end;
        end);
        CoruTask.New("Shop", function()
            while true do
                Functions.ShopSeed();
                Functions.ShopGear();
                Functions:ShopPet();
                twait(0.1);
            end;
        end);
        CoruTask.New("Events", function()
            while true do
                if (not EventsCon.Seeds.Gold and not EventsCon.Seeds.Rainbow) or CoreDestroyed then
                    CoruTask.Close("Events");
                end; Functions:AutoCollectSeeds(); twait(0.1);
            end;
        end);

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "Grow A Garden 2",
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
                Garden = Window:Tab({Title="Garden", Icon="house"}),
                Harvest = Window:Tab({Title="Harvest", Icon="cog"}),
                Sell = Window:Tab({Title="Sell", Icon="bitcoin"}),
                Shop = Window:Tab({Title="Shop", Icon="hand-coins"}),
                Events = Window:Tab({Title="Events", Icon="party-popper"}),
                
                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);
            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.Garden, ScriptData.AutoData.GardenTab, "Garden");
            Windy:CreateComponent(Tabs.Harvest, ScriptData.AutoData.HarvestTab, "Harvest");
            Windy:CreateComponent(Tabs.Sell, ScriptData.AutoData.SellTab, "Sell");
            Windy:CreateComponent(Tabs.Shop, ScriptData.AutoData.ShopTab, "Shop");
            Windy:CreateComponent(Tabs.Events, ScriptData.AutoData.EventsTab, "Events");

            Functions.PairData(Tabs.Shop, "Seeds", SeedData);
            Functions.PairData(Tabs.Shop, "Gears", GearData);
            Functions.PairData(Tabs.Shop, "Pets", PetData);

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
            ScriptCache.HarvestTab = Tabs.Harvest;
            ScriptCache.SellTab = Tabs.Sell;
            ScriptCache.GardenTab = Tabs.Garden;
        end; local LSecureLoad = function(AUTH_KEY)
            PremiumCheck = false;
            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false;
                
                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if HarvestCon.Auto then
                            CoruTask.Handle("Harvest");
                        end;
                        if SellCon.Auto then
                            CoruTask.Handle("Sell");
                        end;
                        if EventsCon.Seeds.Gold or EventsCon.Seeds.Rainbow then
                            CoruTask.Handle("Events");
                        end;
                        twait(0.1);
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

                    ClientPackage.Noclip(ClientCon.Noclip, selc);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
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

                for i,tbls in pairs(HarvestCon.Schemas) do
                    for _, v in ipairs(tbls) do
                        Functions.PairHarvest(i, v);
                    end;
                end;
                for i,tbls in pairs(SellCon.Schemas) do
                    for _, v in ipairs(tbls) do
                        Functions.PairSell(i, v);
                    end;
                end;

                if not CoruTask.Intialized then
                    CoruTask.Init(WindUI);
                    CoruTask.Intialized = true;

                    while twait() do
                        local gcc = getgc(true); for i=1, #gcc do
                            if AllGardens and PurchaseData and PVC and GVC and TVC then return; end;
                            local v = gcc[i]; if typeof(v) == 'table' then
                                if rawget(v, "PurchasedThisRestock") then
                                    PurchaseData = v.PurchasedThisRestock;
                                elseif rawget(v, "GetAllGardens") then
                                    AllGardens = v:GetAllGardens();
                                    AllProps = v:GetAllProps();
                                    GVC = v;
                                elseif rawget(v, "GetSpawnedPlant") then
                                    PVC = v;
                                elseif rawget(v, "GetSpawnedProp") then
                                    TVC = v;
                                end;
                            end;
                        end;
                    end;
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};



