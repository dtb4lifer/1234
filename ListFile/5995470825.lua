local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[Plasma Hub] : Really? Your account is now at risk for the next ban wave."); end;

local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local UserInputService = GG.UserInputService;
local Instancen = Instance.new;
local Vec3 = Vector3.new;
local Col3 = Color3;
local tble = table;
local math = math;
local str = string;
local CF = CFrame;
local tk = task;
local W = GG.W;
local H = GG.H;
local R = GG.R;
local P = GG.P;

local PlaceId = game.PlaceId;

local CFr = CF.new;
local IsA = game.IsA;
local twait = tk.wait;
local Vec2 = Vector2.new;
local Vec3 = Vector3.new;
local Raycast = W.Raycast;
local GetPlayers = P.GetPlayers;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local IsDescendantOf = game.IsDescendantOf;
local FindFirstChild = game.FindFirstChild;
local FindFirstChildOfClass = game.FindFirstChildOfClass;
local FindFirstAncestorOfClass = game.FindFirstAncestorOfClass;
local GetMouseLocation = UserInputService.GetMouseLocation;

local EMPTYTBL = {};

local RED = Col3.fromRGB(118, 0, 255);
local WHITE = Col3.fromRGB(255, 255, 255);

local VEC232 = Vec3(2,3,2);

local ALWAYSONTOP = Enum.HighlightDepthMode.AlwaysOnTop;
local OCCLUDED = Enum.HighlightDepthMode.Occluded;

GG.Configs = GG.Configs or {
    ["SilentAim"] = {
        ["Target"] = "Head";
        ["Wall Check"] = true;
    };
    ["Aimbot"] = {
        ["Target"] = "Head";
        ["Circle Size"] = 90;
    };
    ["ESP"] = {
        ["Tracer"]=false;
    };
    ["Client"] = {
        ["Client"] = {
            ["FlySpeed"] = 1,
        };
    },
};

local ScriptData = {};

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
    Version = "HyperSV3.03";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, PromptPackage, CoruTask, ESPF, CommonF, CircleF)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;

        local GTarget           = nil;
        local AimRunning        = false;
        local AimbotTarget      = nil;
        local CameraController  = nil;
        local ESPObjects        = GG.ESPObjects;
        local Cam               = GG.W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local Backpack          = selff.Backpack;
        local PSG               = selff.PlayerGui;
        local selc              = selff.Character;
        local HumSelf           = selc and FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf and HumSelf.RootPart;

        local ClientCon         = GG.Configs.Client.Client;
        local SilentAimCon      = GG.Configs.SilentAim;
        local AimbotCon         = GG.Configs.Aimbot;
        local ESPCon            = GG.Configs.ESP;

        local dist              = CommonF.dist;
        local WToView           = Cam.WorldToViewportPoint;

        local IgnoreModel       = WaitForChild(W, "IgnoreThese", 9e9);

        local AimbotCir         = CircleF:new(AimbotCon["Circle Size"]);
        
        local Functions         = {};

        local params = RaycastParams.new();
        params.FilterType = Enum.RaycastFilterType.Exclude;
        params.IgnoreWater = true;

        Functions.isWall = IB_NO_VIRTUALIZE(function(from, HumR, ignore)
            local dir = HumR.Position - from;
            params.FilterDescendantsInstances = ignore or {};
            local result = Raycast(W, from, dir, params);
            if not result then return true; end;
            if result.Instance == HumR then
                return true;
            end; local model = FindFirstAncestorOfClass(HumR, "Model");
            if model and IsDescendantOf(result.Instance, model) then
                return true;
            end; return false;
        end);
        Functions.IsInSight = IB_NO_VIRTUALIZE(function(self, HumR)
            if typeof(Cam) ~= "Instance" then return nil; end;
            local camPos = Cam.CFrame.Position;
            local pos, OnScreen = WToView(Cam, HumR.Position);
            if not OnScreen then return nil; end;
            if SilentAimCon["Wall Check"] then
                return self.isWall(camPos, HumR, {Cam, HumR.Parent, selc, IgnoreModel});
            end; return true;
        end);
        Functions.GetNearestTarget = IB_NO_VIRTUALIZE(function(self, folder, maxDist, deb)
            local camPos, closest = Cam.CFrame.Position, nil;
            local closestDist = maxDist;
            if not SilentAimCon["Ignore Bots"] then
                for _, model in ipairs(GetChildren(folder)) do
                    if not IsA(model, "Model") then continue; end;
                    local Team = GetAttribute(model, "Team");
                    if (Team ~= -1 and Team == GetAttribute(selc, "Team")) or model == selc then
                        continue;
                    end;
                    
                    local Hum = FindFirstChildOfClass(model, "Humanoid");
                    local HumR = FindFirstChild(model, SilentAimCon.Target);

                    if HumR and Hum and Hum.Health > 0 then
                        if self.IsInSight(self, HumR) then
                            local dista = (HumR.Position - camPos).Magnitude;
                            if dista < closestDist then
                                closestDist = dista;
                                closest = HumR;
                            end;
                        end;
                    end;
                end;
            end; if not deb and (not closest or not closestDist) and not SilentAimCon["Ignore Players"] then
                return self.GetNearestTarget(self, W, 10000, true);
            end; return closest, closestDist;
        end);
        Functions.InitializeGC = IB_NO_VIRTUALIZE(function(self, gc)
            if not self.HookedMousePos then
                for _,v in pairs(gc) do
                    if typeof(v) == "table" and rawget(v, "GetMousePos") then
                        local o;o=LowerC(v.GetMousePos, function(...)
                            GTarget = self.GetNearestTarget(self, W.Mobs, 10000);
                            if not SilentAimCon.Enable then return o(...); end;
                            return GTarget and GTarget.Position or o(...);
                        end);
                    end;
                end;
            end;

            for _,v in pairs(gc) do
                if typeof(v) == 'table' then
                    if rawget(v, "CanHit") and not self.HookedCanHit then
                        local o;o = GG.LowerC(v.CanHit, function(...)
                            if not SilentAimCon.Enable or checkcaller() then return o(...); end;
                            return GTarget or o(...);
                        end); self.HookedCanHit = true;
                    elseif typeof(rawget(v, "Hit")) == 'function' and not isfunctionhooked(v.Hit) then
                        pcall(function()
                            local o;o=GG.LowerC(v.Hit, function(selfa, ...)
                                if not SilentAimCon.Enable or not GTarget then GTarget=nil; return o(selfa, ...); end;
                                local a = {...}; a[1] = GTarget; a[2] = GTarget.Position;
                                GTarget = nil;
                                return o(selfa, unpack(a));
                            end);
                        end);
                    end;
                end;
            end;
        end);
        Functions.InitializeGame = IB_NO_VIRTUALIZE(function()
            tk.spawn(function()
                local Arms = WaitForChild(IgnoreModel, "MyArms", 9e9);
                local Controller = WaitForChild(Arms, "AnimationController", 9e9);
                local Animator = FindFirstChildOfClass(Controller, "Animator");
                local Anims = Animator and FindFirstChild(Arms, "Anims");
                if not Anims then return; end; return tk.spawn(function()
                    while true do
                        if Animator and ClientCon["Instant Reload"] then
                            for _, track in next, Animator:GetPlayingAnimationTracks() do
                                pcall(track.AdjustSpeed, track, 9e9);
                            end;
                        end; twait(0.05);
                    end;
                end);
            end);
        end);
        Functions.InitializeChar = IB_NO_VIRTUALIZE(function(self)
            selff.CharacterAdded:Connect(function(char)
                tk.delay(1, function()
                    self:InitializeGC(getgc(true));
                    self.InitializeGame();
                end);
            end);
        end);
        Functions.CancelAimbot = IB_NO_VIRTUALIZE(function(Circle)
            AimbotTarget = nil; return Circle:SetColor(WHITE);
        end);
        Functions.Aimbot = IB_NO_VIRTUALIZE(function(self, Circle)
            local RequiredDistance = AimbotCon["Circle Size"];
            if not AimbotTarget then
                local Mob, Mob2 = ((not AimbotCon["Ignore Bots"] and GetChildren(W.Mobs)) or {}),  ((not AimbotCon["Ignore Players"] and GetPlayers(P)) or {});
                for i=1, #Mob2 do
                    tble.insert(Mob, FindFirstChild(W, Mob2[i].Name));
                end; for i=1, #Mob do
                    local v = Mob[i]; if v ~= nil and v ~= selc and selc then
                        local TargetPart = v and FindFirstChild(v, AimbotCon.Target);
                        if TargetPart and FindFirstChildOfClass(v, "Humanoid") then
                            local Team = v and GetAttribute(v, "Team");
                            if Team ~= -1 and Team == GetAttribute(selc, "Team") then continue; end;
                            local Vector, OnScreen = WToView(Cam, TargetPart.Position);
                            local Distance = (Vec2(GetMouseLocation(UserInputService).X, GetMouseLocation(UserInputService).Y) - Vec2(Vector.X, Vector.Y)).Magnitude;
                            if AimbotCon["Wall Check"] then
                                local HasClear = false;
                                pcall(function()
                                    if not self.isWall(Cam.CFrame.Position, TargetPart, {Cam, TargetPart.Parent, selc, IgnoreModel}) then
                                        HasClear = false;
                                    else
                                        HasClear = true;
                                    end;
                                end); if not HasClear then continue; end;
                            end; if Distance < RequiredDistance and OnScreen then
                                RequiredDistance = Distance;
                                AimbotTarget = v;
                            end;
                        end;
                    end;
                end;
            else
                local TargetPart = FindFirstChild(AimbotTarget, AimbotCon.Target);
                local Hum = FindFirstChild(AimbotTarget, "Humanoid");
                if not Hum or not Hum.Parent or Hum.Health <= 0 then
                    return self.CancelAimbot(Circle);
                end;
                if TargetPart and (Vec2(GetMouseLocation(UserInputService).X, GetMouseLocation(UserInputService).Y) - Vec2(WToView(Cam, TargetPart.Position).X, WToView(Cam, TargetPart.Position).Y)).Magnitude > RequiredDistance then
                    return self.CancelAimbot(Circle);
                end;
            end;
        end);
        Functions.UpdateCamState = IB_NO_VIRTUALIZE(function(target)
            if not ClientCon.ThirdPerson then return; end;
            if not CameraController then
                local gc = getgc(true);
                for i=1, #gc do
                    local v = gc[i];
                    if typeof(v) == 'table' then
                        if rawget(v, "ToggleCamUpdate") then
                            CameraController = v;
                            break;
                        end;
                    end;
                end;
            end; CameraController:ToggleCamUpdate(target);
            CameraController:ToggleCharTransparency(not target and 0 or 1);
        end);
        Functions.ESPBot = IB_NO_VIRTUALIZE(function()
            if not ESPCon.Bots or not selc then return; end;
            local Mobs = GetChildren(W.Mobs); for i=1, #Mobs do
                local v = Mobs[i]; if v then
                    if IsA(v, "Model") then
                        local HumR = FindFirstChild(v, "HumanoidRootPart");
                        local Team = v and GetAttribute(v, "Team");
                        if (Team ~= -1 and Team == GetAttribute(selc, "Team")) or not HumR then continue; end;
                        
                        local ESPExists = FindFirstChild(v, "BoxHandleAdornment") or FindFirstChild(v, "BillboardGui");
                        if not ESPExists then
                            ESPF.ESP("Bot", v, RED, VEC232, false, false, true, EMPTYTBL);
                        end;

                        local Highlight = FindFirstChild(v, "EnemyHighlight");
                        if Highlight then
                            Highlight.DepthMode = ESPCon["Highlight On Top"] and ALWAYSONTOP or OCCLUDED;
                        end;
                    end;
                end;
            end;
            
            local BotObjects = ESPObjects.Bot;
            if BotObjects then
                local boxes = BotObjects.Box or {};
                for i=1, #boxes do
                    local b = boxes[i]; if b then b.Visible = ESPCon.ShowBox; end;
                end;
                local bills = BotObjects.Bill or {};
                for i=1, #bills do
                    local b = bills[i]; 
                    if b then 
                        b.Enabled = ESPCon.ShowText;
                    end;
                end;
            end;
        end);
        Functions.ESPPlayer = IB_NO_VIRTUALIZE(function()
            if not ESPCon.Players or not selc then return; end;
            local PlayersList = GetPlayers(P); for i=1, #PlayersList do
                local plr = PlayersList[i];
                local v = plr.Character or FindFirstChild(W, plr.Name); if v then
                    if IsA(v, "Model") then
                        local HumR = FindFirstChild(v, "HumanoidRootPart");
                        local Team = v and GetAttribute(v, "Team");
                        if (Team ~= -1 and Team == GetAttribute(selc, "Team")) or v == selc or not HumR then continue; end;
                        
                        local ESPExists = FindFirstChild(v, "BoxHandleAdornment") or FindFirstChild(v, "BillboardGui");
                        if not ESPExists then
                            ESPF.ESP("Player", v, RED, VEC232, false, false, true, EMPTYTBL);
                        end;

                        local Highlight = FindFirstChild(v, "EnemyHighlight");
                        if Highlight then
                            Highlight.DepthMode = ESPCon["Highlight On Top"] and ALWAYSONTOP or OCCLUDED;
                        end;
                    end;
                end;
            end;

            local PlayerObjects = ESPObjects.Player;
            if PlayerObjects then
                local boxes = PlayerObjects.Box or {};
                for i=1, #boxes do
                    local b = boxes[i]; if b then b.Visible = ESPCon.ShowBox; end;
                end;
                local bills = PlayerObjects.Bill or {};
                for i=1, #bills do
                    local b = bills[i]; 
                    if b then 
                        b.Enabled = ESPCon.ShowText;
                    end;
                end;
            end;
        end);
        Functions.UpdateTracer = IB_NO_VIRTUALIZE(function(target)
            local PTracer = ESPObjects.Player and ESPObjects.Player.Line or {};
            local BTracer = ESPObjects.Bot and ESPObjects.Bot.Line or {};
            
            local Mobs = GetChildren(W.Mobs);
            for i=1, #BTracer do
                local v = BTracer[i]; 
                if v then
                    local mob = Mobs[i];
                    local HumR = mob and FindFirstChild(mob, "HumanoidRootPart");
                    if target and mob and HumR and IsA(mob, "Model") then
                        local pos, onScreen = WToView(Cam, HumR.Position);
                        if onScreen then
                            v.From = Vec2(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2);
                            v.To = Vec2(pos.X, pos.Y);
                            v.Visible = true;
                        else
                            v.Visible = false;
                        end;
                    else
                        v.Visible = false;
                    end;
                end;
            end;

            local PlayersList = GetPlayers(P);
            for i=1, #PTracer do
                local v = PTracer[i]; 
                if v then
                    local plr = PlayersList[i];
                    local char = plr and (plr.Character or FindFirstChild(W, plr.Name));
                    local HumR = char and FindFirstChild(char, "HumanoidRootPart");
                    if target and char and HumR and IsA(char, "Model") and char ~= selc then
                        local pos, onScreen = WToView(Cam, HumR.Position);
                        if onScreen then
                            v.From = Vec2(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2);
                            v.To = Vec2(pos.X, pos.Y);
                            v.Visible = true;
                        else
                            v.Visible = false;
                        end;
                    else
                        v.Visible = false;
                    end;
                end;
            end;
        end);

        CoruTask.New("ESP Overhead", IB_NO_VIRTUALIZE(function()
            while true do
                if not ESPCon.Bots and not ESPCon.Players then
                    CoruTask.Close("ESP Overhead");
                end;
                Functions.ESPBot();
                Functions.ESPPlayer();
                twait(0.1);
            end;
        end));

        ScriptData.AutoData = {
            ClientTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Third Person", EN2="Make the camera switch between first person and third person.", TH1="à¸¡à¸¸à¸¡à¸¡à¸­à¸‡à¸šà¸¸à¸„à¸„à¸¥à¸—à¸µà¹ˆà¸ªà¸²à¸¡", TH2="à¹€à¸›à¸¥à¸µà¹ˆà¸¢à¸™à¸¡à¸¸à¸¡à¸à¸¥à¹‰à¸­à¸‡à¹€à¸›à¹‡à¸™à¸šà¸¸à¸„à¸„à¸¥à¸—à¸µà¹ˆà¸ªà¸²à¸¡", Bindable="+", Path="Client/ThirdPerson", Callback=IB_NO_VIRTUALIZE(function(state)
                            ClientCon.ThirdPerson = state;
                            Functions.UpdateCamState(not state);
                            if not CameraController then return; end;
                            if Cam and HumSelf then
                                Cam.CameraType = Enum.CameraType.Custom;
                                Cam.CameraSubject = HumSelf;
                                if not state then
                                    CameraController:ToggleCamUpdate(true);
                                    CameraController:ToggleCharTransparency(1);
                                end;
                            end;
                        end)},
                        {type="Toggle", EN="Instant Reload", EN2="Faster reloading. This function was not approved by Plasma, which means we don't know whether it will be detected.", TH1="à¸£à¸µà¹‚à¸«à¸¥à¸”à¸›à¸·à¸™à¸—à¸±à¸™à¸—à¸µ", TH2="à¸£à¸µà¹‚à¸«à¸¥à¸”à¹€à¸£à¹‡à¸§à¸‚à¸¶à¹‰à¸™; à¸Ÿà¸±à¸‡à¸à¹Œà¸Šà¸±à¸™à¸™à¸µà¹‰à¹„à¸¡à¹ˆà¹„à¸”à¹‰à¸£à¸±à¸šà¸à¸²à¸£à¸­à¸™à¸¸à¸¡à¸±à¸•à¸´à¸ˆà¸²à¸ Plasma à¸‹à¸¶à¹ˆà¸‡à¸«à¸¡à¸²à¸¢à¸„à¸§à¸²à¸¡à¸§à¹ˆà¸²à¹€à¸£à¸²à¹„à¸¡à¹ˆà¸—à¸£à¸²à¸šà¸§à¹ˆà¸²à¸ˆà¸°à¸–à¸¹à¸à¸•à¸£à¸§à¸ˆà¸žà¸šà¸«à¸£à¸·à¸­à¹„à¸¡à¹ˆ", Path="Client/Instant Reload"},
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="à¹à¸¡à¸žà¸ªà¸§à¹ˆà¸²à¸‡", TH2="à¸¡à¸­à¸‡à¹€à¸«à¹‡à¸™à¸‡à¹ˆà¸²à¸¢à¸‚à¸¶à¹‰à¸™", Path="Client/Full Bright"},
                        {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="à¸¥à¸­à¸¢", TH2="à¸—à¸³à¹ƒà¸«à¹‰à¸•à¸±à¸§à¸¥à¸°à¸„à¸£à¹€à¸”à¸´à¸™à¸šà¸™à¸­à¸²à¸à¸²à¸¨à¹„à¸”à¹‰", Path="Client/Float"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="à¸„à¸§à¸²à¸¡à¹€à¸£à¹‡à¸§à¹ƒà¸™à¸à¸²à¸£à¹€à¸”à¸´à¸™à¹à¸šà¸šà¸§à¸²à¸£à¹Œà¸›", TH2="à¸›à¸£à¸±à¸šà¸„à¸§à¸²à¸¡à¹€à¸£à¹‡à¸§à¹ƒà¸™à¸à¸²à¸£à¹€à¸”à¸´à¸™à¹à¸šà¸šà¸§à¸²à¸£à¹Œà¸›", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™à¹€à¸”à¸´à¸™à¹à¸šà¸šà¸§à¸²à¸£à¹Œà¸›", TH2="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™à¹€à¸”à¸´à¸™à¹‚à¸”à¸¢à¸à¸²à¸£à¸§à¸²à¸£à¹Œà¸›à¹„à¸›à¹€à¸£à¸·à¹ˆà¸­à¸¢à¹†", Path="Client/Enable TeleportWalk"},
                        {type="Slider", EN="Jump Power", EN2="Change the power of your jump.", TH1="à¸„à¸§à¸²à¸¡à¹à¸£à¸‡à¹ƒà¸™à¸à¸²à¸£à¸à¸£à¸°à¹‚à¸”à¸”", TH2="à¸›à¸£à¸±à¸šà¸„à¸§à¸²à¸¡à¹à¸£à¸‡à¹ƒà¸™à¸à¸²à¸£à¸à¸£à¸°à¹‚à¸”à¸”", Value={Min=1, Max=300}, Path="Client/JumpPower"},
                        {type="Toggle", EN="Enable Jump Power", EN2="Enable jump power modification.", TH1="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™à¸„à¸§à¸²à¸¡à¹à¸£à¸‡à¹ƒà¸™à¸à¸²à¸£à¸à¸£à¸°à¹‚à¸”à¸”", TH2="à¸›à¸£à¸±à¸šà¸„à¸§à¸²à¸¡à¹à¸£à¸‡à¹ƒà¸™à¸à¸²à¸£à¸à¸£à¸°à¹‚à¸”à¸”", Path="Client/Enable JumpPower"},
                    }, Title="Client", Open=true};
                }};
            };
            SilentAimTab = {
                {type="Dropdown", EN="Target", EN2="Select where the script should aim at.", TH1="à¹€à¸›à¹‰à¸²à¸«à¸¡à¸²à¸¢", TH2="à¹€à¸¥à¸·à¸­à¸à¸ˆà¸¸à¸”à¸—à¸µà¹ˆà¸ªà¸„à¸£à¸´à¸›à¸„à¸§à¸£à¹€à¸¥à¹‡à¸‡", Values={"Head", "HumanoidRootPart"}, Path="Target"},
                {type="Toggle", EN="Wall Check", EN2="You can turn this off in Sniper gamemode; Don't abuse it.", TH1="à¹€à¸Šà¹‡à¸„à¸à¸³à¹à¸žà¸‡", TH2="à¸ªà¸²à¸¡à¸²à¸£à¸–à¸›à¸´à¸”à¹„à¸”à¹‰à¹ƒà¸™à¹‚à¸«à¸¡à¸” Sniper à¹à¸•à¹ˆà¸à¹‡à¸­à¸¢à¹ˆà¸²à¹ƒà¸Šà¹‰à¸šà¹ˆà¸­à¸¢à¸”à¸µà¸à¸§à¹ˆà¸²", Path="Wall Check"},
                {type="Toggle", EN="Ignore Bots", EN2="Blocking the script from silent aiming at bots.", TH1="à¹„à¸¡à¹ˆà¸ªà¸™à¹ƒà¸ˆà¸šà¸­à¸—", TH2="à¸›à¹‰à¸­à¸‡à¸à¸±à¸™ silent aiming à¸šà¸­à¸—", Path="Ignore Bots"},
                {type="Toggle", EN="Ignore Players", EN2="Blocking the script from silent aiming at players.", TH1="à¹„à¸¡à¹ˆà¸ªà¸™à¹ƒà¸ˆà¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™", TH2="à¸›à¹‰à¸­à¸‡à¸à¸±à¸™ silent aiming à¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™", Path="Ignore Players"},
                {type="Toggle", EN="Enable", EN2="Enable silent aiming.", TH1="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™", TH2="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™ silent aiming", Bindable="+", Path="Enable"},
            };
            AimbotTab = {
                {type="Dropdown", EN="Target", EN2="Select where the script should aim at.", TH1="à¹€à¸›à¹‰à¸²à¸«à¸¡à¸²à¸¢", TH2="à¹€à¸¥à¸·à¸­à¸à¸ˆà¸¸à¸”à¸—à¸µà¹ˆà¸ªà¸„à¸£à¸´à¸›à¸„à¸§à¸£à¹€à¸¥à¹‡à¸‡", Values={"Head", "HumanoidRootPart"}, Path="Target"},
                {type="Toggle", EN="Wall Check", EN2="You can turn this off in Sniper gamemode; Don't abuse it.", TH1="à¹€à¸Šà¹‡à¸„à¸à¸³à¹à¸žà¸‡", TH2="à¸ªà¸²à¸¡à¸²à¸£à¸–à¸›à¸´à¸”à¹„à¸”à¹‰à¹ƒà¸™à¹‚à¸«à¸¡à¸” Sniper à¹à¸•à¹ˆà¸à¹‡à¸­à¸¢à¹ˆà¸²à¹ƒà¸Šà¹‰à¸šà¹ˆà¸­à¸¢à¸”à¸µà¸à¸§à¹ˆà¸²", Path="Wall Check"},
                {type="Toggle", EN="Ignore Bots", EN2="Blocking the script from silent aiming at bots.", TH1="à¹„à¸¡à¹ˆà¸ªà¸™à¹ƒà¸ˆà¸šà¸­à¸—", TH2="à¸›à¹‰à¸­à¸‡à¸à¸±à¸™ silent aiming à¸šà¸­à¸—", Path="Ignore Bots"},
                {type="Toggle", EN="Ignore Players", EN2="Blocking the script from silent aiming at players.", TH1="à¹„à¸¡à¹ˆà¸ªà¸™à¹ƒà¸ˆà¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™", TH2="à¸›à¹‰à¸­à¸‡à¸à¸±à¸™ silent aiming à¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™", Path="Ignore Players"},
                {type="Space"}; {type="Space"};
                {type="Slider", Title="Circle Size", TH1="à¸‚à¸™à¸²à¸”à¸§à¸‡à¸à¸¥à¸¡", Value={Min=1, Max=360}, Step=0.1, Path="Circle Size"},
                {type="Toggle", Title="Show Circle", TH1="à¹à¸ªà¸”à¸‡à¸§à¸‡à¸à¸¥à¸¡", Path="Show Circle"},
                {type="Space"}; {type="Space"};
                {type="Toggle", EN="Enable", EN2="You need to hold/press the key you binded to; not just click the key. Before holding the key; you have to enable it first.", TH1="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™", TH2="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™ silent aiming", Bindable="++", BindToGlobal="AimKey", Path="Enable"},
            };
            ESPTab = {
                {type="Toggle", EN="Bots", EN2="Show ESP bots.", TH1="à¸šà¸­à¸—", TH2="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™ ESP à¸šà¸­à¸—", Path="Bots", Callback=IB_NO_VIRTUALIZE(function(state)
                    ESPCon.Bots = state;
                    ESPF.Destroy("Bot");
                end)},
                {type="Toggle", EN="Players", EN2="Show ESP players.", TH1="à¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™", TH2="à¹€à¸›à¸´à¸”à¹ƒà¸Šà¹‰à¸‡à¸²à¸™ ESP à¸œà¸¹à¹‰à¹€à¸¥à¹ˆà¸™", Path="Players", Callback=IB_NO_VIRTUALIZE(function(state)
                    ESPCon.Players = state;
                    ESPF.Destroy("Player");
                end)},
                {type="Space"}; {type="Space"};
                {type="Toggle", EN="Show Text", EN2="This is a charm ESP from the script package.", TH1="à¸‚à¹‰à¸­à¸„à¸§à¸²à¸¡", TH2="à¹à¸ªà¸”à¸‡à¸Šà¸·à¹ˆà¸­à¸¨à¸±à¸•à¸£à¸¹", Path="ShowText"},
                {type="Toggle", EN="Show Box", EN2="This is a charm ESP from the script package.", TH1="à¸à¸¥à¹ˆà¸­à¸‡", TH2="à¹à¸ªà¸”à¸‡à¸à¸£à¸­à¸šà¸¨à¸±à¸•à¸£à¸¹", Path="ShowBox"},
                {type="Toggle", EN="Highlight On Top", EN2="This is a highlight ESP from the game itself. This will make the highlight visible through walls.", TH1="Highlight On Top", TH2="à¸¡à¸­à¸‡à¹„à¸®à¹„à¸¥à¸—à¹Œà¸—à¸°à¸¥à¸¸à¸à¸³à¹à¸žà¸‡", Path="Highlight On Top"},
                {type="Toggle", EN="Tracer", EN2="Tracer line from the target to your crosshair.", TH1="à¹€à¸ªà¹‰à¸™à¹€à¸¥à¹€à¸‹à¸­à¸£à¹Œ", TH2="à¹€à¸ªà¹‰à¸™à¹€à¸¥à¹€à¸‹à¸­à¸£à¹Œà¸ˆà¸²à¸à¹€à¸›à¹‰à¸²à¸«à¸¡à¸²à¸¢à¹„à¸›à¸¢à¸±à¸‡à¸ˆà¸¸à¸”à¸à¸¶à¹ˆà¸‡à¸à¸¥à¸²à¸‡à¸‚à¸­à¸‡à¸«à¸™à¹‰à¸²à¸ˆà¸­", Path="Tracer"},
            };
        };

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "The Mimic",
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
                SilentAim = Window:Tab({Title="Silent Aim", Icon="skull"}),
                Aimbot = Window:Tab({Title="Aimbot", Icon="crosshair"}),
                ESP = Window:Tab({Title="ESP", Icon="eye"}),
                
                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);
            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.SilentAim, ScriptData.AutoData.SilentAimTab, "SilentAim");
            Windy:CreateComponent(Tabs.Aimbot, ScriptData.AutoData.AimbotTab, "Aimbot");
            Windy:CreateComponent(Tabs.ESP, ScriptData.AutoData.ESPTab, "ESP");

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function(AUTH_KEY)
            PremiumCheck = false;
            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false;
                ClientCon.JumpPower = HumSelf and HumSelf.JumpPower or 50;
                AimbotCir:SetColor(RED); AimbotCir:SetThickness(2);

                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if ESPCon.Bots or ESPCon.Players then
                            CoruTask.Handle("ESP Overhead");
                        end; twait(0.1);
                    end;
                end));

                CoreConnection[1] = GG.H.Stepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[1] then
                        CoreConnection[1]:Disconnect(); CoreConnection[1] = nil;
                        return;
                    end;

                    Backpack = selff.Backpack;
                    selc = selff.Character;
                    HumSelf = selc and FindFirstChildOfClass(selc, "Humanoid");
                    HumRSelf = HumSelf and HumSelf.RootPart;

                    ClientPackage.UpdatePosition(ClientCon.Float, ForceFloat, HumRSelf);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
                    ClientPackage.JumpPower(ClientCon["Enable JumpPower"], ClientCon.JumpPower, HumSelf);
                end));
                CoreConnection[2] = GG.H.Heartbeat:Connect(IB_NO_VIRTUALIZE(function(delta)
                    if CoreDestroyed and CoreConnection[2] then
                        CoreConnection[2]:Disconnect(); CoreConnection[2] = nil;
                        return;
                    end;

                    if ClientCon["Enable TeleportWalk"] and selc and HumSelf and HumSelf.MoveDirection.Magnitude > 0 then
                        selc:TranslateBy(HumSelf.MoveDirection * ClientCon["TeleportWalk Speed"] * delta * 10);
                    end;
                end));
                CoreConnection[3] = GG.H.RenderStepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[3] then
                        CoreConnection[3]:Disconnect(); CoreConnection[3] = nil;
                        return;
                    end;

                    AimbotCir:SetRadius(AimbotCon["Circle Size"]);
                    AimbotCir:SetVisible(AimbotCon["Show Circle"]);
                    AimbotCir:SetPosition(GetMouseLocation(UserInputService));

                    if not AimbotCon.Enable or not AimRunning then return; end;
                    Functions:Aimbot(AimbotCir);

                    local Target = AimbotTarget and FindFirstChild(AimbotTarget, AimbotCon.Target);
                    if Target then
                        Cam.CFrame = CFr(Cam.CFrame.Position, Target.Position);
                        AimbotCir:SetColor(RED);
                    end;
                end));
                CoreConnection[4] = GG.H.RenderStepped:Connect(IB_NO_VIRTUALIZE(function()
                    Functions.UpdateTracer(ESPCon.Tracer);
                end));

                if userIdentify.device == "PC" then
                    if not ScriptCache.AlreadyCMDM then
                        ScriptCache.AlreadyCMDM = true;
                    end;
                end;

                if not CoruTask.Intialized then
                    Functions:InitializeChar();

                    CoruTask.Init(ScriptCache.WindUI);
                    CoruTask.Intialized = true;

                    UserInputService.InputBegan:Connect(IB_NO_VIRTUALIZE(function(input, gpe)
                        local aimKey = GlobalBinds.AimKey;
                        if input.KeyCode.Name == aimKey or input.UserInputType.Name == aimKey then
                            AimRunning = true;
                            Functions.UpdateCamState(false);
                        end;
                    end));
                    UserInputService.InputEnded:Connect(IB_NO_VIRTUALIZE(function(input, gpe)
                        local aimKey = GlobalBinds.AimKey;
                        if input.KeyCode.Name == aimKey or input.UserInputType.Name == aimKey then
                            AimRunning = false;
                            AimbotCir:SetColor(WHITE);
                            Functions.UpdateCamState(not ClientCon.ThirdPerson);
                        end;
                    end));
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};


