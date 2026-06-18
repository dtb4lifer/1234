local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[Plasma Hub] : Really? Your account is now at risk for the next ban wave."); end;

local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local UserInputService = GG.UserInputService;
local Instancen = Instance.new;
local Debris = GG.Debris;
local Vec3 = Vector3.new;
local Col3 = Color3;
local tble = table;
local str = string;
local math = math;
local CF = CFrame;
local tk = task;
local H = GG.H;
local W = GG.W;

local EMPTYTBL = {};

local RED = Col3.fromRGB(118, 0, 255);
local WHITE = Col3.fromRGB(255, 255, 255);

local VEC232 = Vec3(2,3,2);

local CFr = CF.new;
local IsA = game.IsA;
local twait = tk.wait;
local oclock = os.clock;
local Vec2 = Vector2.new;
local Vec3 = Vector3.new;
local Raycast = W.Raycast;
local mrandom = math.random;
local GetPlayers = P.GetPlayers;
local GetChildren = game.GetChildren;
local WaitForChild = game.WaitForChild;
local IsDescendantOf = game.IsDescendantOf;
local FindFirstChild = game.FindFirstChild;
local FindFirstChildOfClass = game.FindFirstChildOfClass;
local GetMouseLocation = UserInputService.GetMouseLocation;
local FindFirstAncestorOfClass = game.FindFirstAncestorOfClass;

local ScriptData = {};

GG.Configs = GG.Configs or {
    ["SilentAim"] = {
        ["Target"] = "Head";
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

return {
    Version = "FlickV3.01";
    Function = function(CorePackage, WindLib, IntroLib, Windy, CoruTask, ESPF, CommonF, CircleF)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;

        local TimerC            = 0;
        local GTarget           = nil;
        local AimRunning        = false;
        local AimbotTarget      = nil;
        local ActiveShots       = {};
        local Cam               = W.CurrentCamera;
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
        local ESPObjects        = GG.ESPObjects;

        local dist              = CommonF.dist;
        local WToView           = Cam.WorldToViewportPoint;

        local LobbyMenu         = WaitForChild(PSG, "LobbyMenu", 9e9);

        local ModuleScripts     = WaitForChild(R, "ModuleScripts");
        local GunModules        = WaitForChild(ModuleScripts, "GunModules");

        local Projectile        = require(WaitForChild(GunModules, "Projectile", 9e9));
        local BulletHandler     = require(WaitForChild(GunModules, "BulletHandler", 9e9));
        local ProjectileRender  = require(WaitForChild(GunModules, "ProjectileRender", 9e9));

        local AimbotCir         = CircleF:new(AimbotCon["Circle Size"]);
        
        local Functions         = {randomObjs={"Head", "HumanoidRootPart"}};
        local RE                = {};

        local params = RaycastParams.new();
        params.FilterType = Enum.RaycastFilterType.Exclude;
        params.IgnoreWater = true;

        Functions.InitializeGC = IB_NO_VIRTUALIZE(function()
            local o;o=GG.LowerC(BulletHandler.Fire, newcclosure(function(data)
                if not GTarget then return o(data); end;
                local origin, visualOrigin = data.Origin, data.VisualOrigin;
                local direction, force = data.Direction, data.Force;
                local gravity, bulletId = data.Gravity, data.BulletId;
                local visuals, logic = data.Visuals, data.Logic;
                local network, misc = data.Network, data.Misc;
                local target = GTarget;
                local direction = (target.Position - origin).Unit;
                local endpoint = origin + direction * 800;

                misc.CamCFrame = CFr(origin, target.Position);
                if (endpoint - visualOrigin).Magnitude > 4 then
                    local renderData = {
                        Index = bulletId, Owner = network.Character,
                        Origin = visualOrigin, Endpoint = endpoint,
                        Force = force, Gravity = gravity,
                        Wind = Vec3(0, 0, 0), Life = 5,
                        Type = visuals.BulletType
                    }; ProjectileRender:Cast(renderData);
                    network.RenderEvent:FireServer(renderData);
                end; local projectile = Projectile.new(gravity, Vector3.zero, 5, false);
                ActiveShots[bulletId] = tk.spawn(function()
                    local _, hitResult = projectile:Cast(bulletId, origin, endpoint, force);
                    local hitPosition, hitCFrame = endpoint, nil;
                    local hitInstance, hitPlayer = nil, false;
                    if hitResult then
                        hitPosition = hitResult.Position;
                        hitCFrame = CFr(hitResult.Position, hitResult.Position + hitResult.Normal);
                        hitInstance = hitResult.Instance;
                        local model = FindFirstAncestorOfClass(hitInstance, "Model");
                        if model and FindFirstChild(model, "Humanoid") and model.Humanoid.Health > 0 then
                            hitPlayer = true; if FindFirstChild(PSG, "GunOverlay") then
                                local overlay = PSG.GunOverlay.ScreenSize;
                                if logic.HitSound then
                                    local sound = logic.HitSound:Clone();
                                    sound.Parent = overlay;
                                    sound:Play();
                                    Debris:AddItem(sound, 1);
                                end; if logic.HitMarker then
                                    local marker = logic.HitMarker:Clone();
                                    marker.Parent = overlay;
                                    Debris:AddItem(marker, 0.05);
                                end;
                            end;
                        end;
                    end; local resultData = {
                        Index = bulletId, CFrame = hitCFrame, Effect = visuals.HitEffect, HitPlayer = hitPlayer,
                        Explosive = logic.IsExplosive, ExpRadius = logic.ExplosionRadius, ExpColor = logic.ExplosionColor,
                        ExpSound = logic.ExplosionSoundId, Origin = visualOrigin, IsLaser = logic.IsLaser,
                        LaserColor = logic.LaserColor, LaserWidth = logic.LaserWidth, LaserTime = logic.LaserTime,
                        LaserTexture = logic.LaserTexture, LaserSpeed = logic.LaserSpeed, LaserLength = logic.LaserLength, LaserEmission = logic.LaserEmission
                    }; network.CheckShotEvent:FireServer(
                        misc.AmmoCount, misc.Spread, misc.MaxAmmo,
                        misc.ReloadTime, misc.CamCFrame, hitPosition,
                        hitInstance, misc.NewSeed, bulletId
                    ); ProjectileRender:Delete(resultData);
                    network.FinishedEvent:FireServer(resultData);
                    ActiveShots[bulletId] = nil;
                end);
            end));
        end);
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
            return self.isWall(camPos, HumR, {Cam, HumR.Parent, selc, FindFirstChild(W, "ViewModel")});
        end);
        Functions.getNearestPlayer = IB_NO_VIRTUALIZE(function(self)
            local Target = if SilentAimCon.Target == "Random" then self.randomObjs[math.random(1, #self.randomObjs)] else SilentAimCon.Target;
            if not selc or not selc.Parent or not FindFirstChild(selc, Target) then
                return nil;
            end;  local camPos = Cam.CFrame.Position;
            local nearestTarget, shortestDistance = nil, math.huge;
            local PlayersList = GetPlayers(P); for i = 1, #PlayersList do
                local player = PlayersList[i];
                if player ~= selff then
                    local targetCharacter = player.Character;
                    local Hum = targetCharacter and FindFirstChildOfClass(targetCharacter, "Humanoid");
                    local root = targetCharacter and FindFirstChild(targetCharacter, Target);
                    if root and Hum and Hum.Health > 0 then
                        if self.IsInSight(self, root) then
                            local distance = dist(root.Position);
                            if distance < shortestDistance then
                                shortestDistance = distance;
                                nearestTarget = root;
                            end;
                        end;
                    end;
                end;
            end; return nearestTarget, shortestDistance;
        end);
        Functions.CancelAimbot = IB_NO_VIRTUALIZE(function(Circle)
            AimbotTarget = nil; return Circle:SetColor(WHITE);
        end);
        Functions.Aimbot = IB_NO_VIRTUALIZE(function(self, Circle)
            local RequiredDistance = AimbotCon["Circle Size"];
            if not AimbotTarget then
                local Mob=GetPlayers(P);
                 for i=1, #Mob do
                    local v = Mob[i]; v = v and v.Character if v ~= nil and v ~= selc and selc then
                        local TargetPart = v and FindFirstChild(v, AimbotCon.Target);
                        local Hum = FindFirstChildOfClass(v, "Humanoid");
                        if TargetPart and Hum and Hum.Health > 0 then
                            local Vector, OnScreen = WToView(Cam, TargetPart.Position);
                            local Distance = (Vec2(GetMouseLocation(UserInputService).X, GetMouseLocation(UserInputService).Y) - Vec2(Vector.X, Vector.Y)).Magnitude;
                            local HasClear = false;
                            pcall(function()
                                if not self.isWall(Cam.CFrame.Position, TargetPart, {Cam, TargetPart.Parent, selc, FindFirstChild(W,"ViewModel")}) then
                                    HasClear = false;
                                else
                                    HasClear = true;
                                end;
                            end); if not HasClear then continue; end;
                            if Distance < RequiredDistance and OnScreen then
                                RequiredDistance = Distance;
                                AimbotTarget = v;
                            end;
                        end;
                    end;
                end;
            else
                local TargetPart = FindFirstChild(AimbotTarget, AimbotCon.Target);
                local Hum = FindFirstChildOfClass(AimbotTarget, "Humanoid");
                if not TargetPart or not Hum or Hum.Health <= 0 then
                    return self.CancelAimbot(Circle);
                elseif (Vec2(GetMouseLocation(UserInputService).X, GetMouseLocation(UserInputService).Y) - Vec2(WToView(Cam, TargetPart.Position).X, WToView(Cam, TargetPart.Position).Y)).Magnitude > RequiredDistance then
                    return self.CancelAimbot(Circle);
                end;
            end;
        end);
        Functions.ESPPlayers = IB_NO_VIRTUALIZE(function()
            local Mobs = GetPlayers(P);
            for i=1, #Mobs do
                local v = Mobs[i]; v = v and v.Character;
                if v and v ~= selc and v.Parent then
                    local Box = FindFirstChild(v, "BoxHandleAdornment");
                    local Bil = FindFirstChild(v, "BillboardGui")
                    local HumR = FindFirstChild(v, "HumanoidRootPart");
                    if not HumR then continue; end;
                    if not Box then
                        ESPF.ESP("P", v, RED, VEC232, false, false, true, EMPTYTBL);
                    end;
                end;
            end; local BotObjects = ESPObjects.P;
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
        Functions.UpdateTracer = IB_NO_VIRTUALIZE(function(target)
            local PTracer = ESPObjects.P and ESPObjects.P.Line or {};
            local PlayersList = GetPlayers(P); 
            local lineIndex = 1;
            for i=1, #PlayersList do
                local plr = PlayersList[i];
                local char = plr and (plr.Character or FindFirstChild(W, plr.Name));
                local HumR = char and FindFirstChild(char, "HumanoidRootPart");
                if char and char ~= selc and char.Parent and HumR then
                    local v = PTracer[lineIndex];
                    if v then
                        if target and IsA(char, "Model") then
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
                    lineIndex = lineIndex + 1;
                end;
            end; for i = lineIndex, #PTracer do
                if PTracer[i] then PTracer[i].Visible = false; end;
            end;
        end);

        ScriptData.AutoData = {
            SilentAimTab = {
                {type="Paragraph", EN="Wall Check & Look Direction", EN2="These 2 are forced use by the script due to Anti Cheat. These won't be show in the setting.", TH1="เช็คกำแพง & ทิศทางที่มอง", TH2="สองอย่างนี้สคริปจะบังคับใช้เนื่องจากกันโปร 2อย่างนี้จะไม่แสดงในการตั้งค่า"},
                {type="Dropdown", EN="Target", EN2="Select where the script should aim at.", TH1="เป้าหมาย", TH2="เลือกจุดที่สคริปควรเล็ง", Values={"Head", "HumanoidRootPart"}, Path="Target"},
                {type="Toggle", EN="Auto Fire", EN2="Automatically fire when the target is in sight.", TH1="ยิงอัตโนมัติ", TH2="ยิงอัตโนมัติเมื่อเป้าหมายอยู่ในสายตา", Bindable="+", Path="Auto Fire"},
                {type="Toggle", EN="Enable", EN2="Enable silent aiming.", TH1="เปิดใช้งาน", TH2="เปิดใช้งาน silent aiming", Bindable="+", Path="Enable"},
            };
            AimbotTab = {
                {type="Paragraph", EN="Wall Check & Look Direction", EN2="These 2 are forced use by the script due to Anti Cheat. These won't be show in the setting.", TH1="เช็คกำแพง & ทิศทางที่มอง", TH2="สองอย่างนี้สคริปจะบังคับใช้เนื่องจากกันโปร 2อย่างนี้จะไม่แสดงในการตั้งค่า"},
                {type="Dropdown", EN="Target", EN2="Select where the script should aim at.", TH1="เป้าหมาย", TH2="เลือกจุดที่สคริปควรเล็ง", Values={"Head", "HumanoidRootPart"}, Path="Target"},
                {type="Space"}; {type="Space"};
                {type="Slider", Title="Circle Size", TH1="ขนาดวงกลม", Value={Min=1, Max=360}, Step=0.1, Path="Circle Size"},
                {type="Toggle", Title="Show Circle", TH1="แสดงวงกลม", Path="Show Circle"},
                {type="Space"}; {type="Space"};
                {type="Toggle", EN="Enable", EN2="You need to hold/press the key you binded to; not just click the key. Before holding the key; you have to enable it first.", TH1="เปิดใช้งาน", TH2="เปิดใช้งาน silent aiming", Bindable="++", BindToGlobal="AimKey", Path="Enable"},
            };
            ESPTab = {
                {type="Toggle", EN="Players", EN2="Show ESP players.", TH1="ผู้เล่น", TH2="เปิดใช้งาน ESP ผู้เล่น", Path="Players", Callback=IB_NO_VIRTUALIZE(function(state)
                    ESPCon.Players = state;
                    ESPF.Destroy("Player");
                end)},
                {type="Space"}; {type="Space"};
                {type="Toggle", EN="Show Text", EN2="This is a charm ESP from the script package.", TH1="ข้อความ", TH2="แสดงชื่อศัตรู", Path="ShowText"},
                {type="Toggle", EN="Show Box", EN2="This is a charm ESP from the script package.", TH1="กล่อง", TH2="แสดงกรอบศัตรู", Path="ShowBox"},
                {type="Toggle", EN="Tracer", EN2="Tracer line from the target to your crosshair.", TH1="เส้นเลเซอร์", TH2="เส้นเลเซอร์จากเป้าหมายไปยังจุดกึ่งกลางของหน้าจอ", Path="Tracer"},
            };
        };

        CoruTask.New("ESP", IB_NO_VIRTUALIZE(function()
            while true do
                if not ESPCon.Players or CoreDestroyed then
                    CoruTask.Close("ESP");
                end; Functions.ESPPlayers();
                twait(0.1);
            end;
        end));

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "[FPS] Flick",
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

                Div1 = Window:Divider(),
                SilentAim = Window:Tab({Title="Silent Aim", Icon="skull"}),
                Aimbot = Window:Tab({Title="Aimbot", Icon="crosshair"}),
                ESP = Window:Tab({Title="ESP", Icon="eye"}),

                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.SilentAim, ScriptData.AutoData.SilentAimTab, "SilentAim");
            Windy:CreateComponent(Tabs.Aimbot, ScriptData.AutoData.AimbotTab, "Aimbot");
            Windy:CreateComponent(Tabs.ESP, ScriptData.AutoData.ESPTab, "ESP");

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function()
            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false;
                AimbotCir:SetColor(RED); AimbotCir:SetThickness(2);
                
                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if SilentAimCon.Enable then
                            GTarget = Functions:getNearestPlayer();
                            if GTarget and not LobbyMenu.Enabled then
                                if SilentAimCon["Auto Fire"] and oclock() - TimerC >= 0.25 then
                                    TimerC = oclock(); mouse1click();
                                end;
                            end;
                        end; if ESPCon.Players then
                            CoruTask.Handle("ESP");
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
                end));
                CoreConnection[2] = GG.H.RenderStepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[2] then
                        CoreConnection[2]:Disconnect(); CoreConnection[2] = nil;
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
                CoreConnection[3] = GG.H.RenderStepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[3] then
                        CoreConnection[3]:Disconnect(); CoreConnection[3] = nil;
                        return;
                    end; Functions.UpdateTracer(ESPCon.Tracer);
                end));

                if not CoruTask.Intialized then
                    Functions.InitializeGC();
                    
                    CoruTask.Init(ScriptCache.WindUI);
                    CoruTask.Intialized = true;

                    UserInputService.InputBegan:Connect(IB_NO_VIRTUALIZE(function(input, gpe)
                        local aimKey = GlobalBinds.AimKey;
                        if input.KeyCode.Name == aimKey or input.UserInputType.Name == aimKey then
                            AimRunning = true;
                        end;
                    end));
                    UserInputService.InputEnded:Connect(IB_NO_VIRTUALIZE(function(input, gpe)
                        local aimKey = GlobalBinds.AimKey;
                        if input.KeyCode.Name == aimKey or input.UserInputType.Name == aimKey then
                            AimRunning = false;
                            AimbotCir:SetColor(WHITE);
                        end;
                    end));
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};
