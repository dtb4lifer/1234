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
local VEC0M0 = Vec3(0, math.huge, 0);

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

local ScriptData = {VECNUM={}};
local VECNUM = ScriptData.VECNUM;

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
    Version = "OneTapV3.01";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, CoruTask, ESPF, CommonF, CircleF)
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
        local PSS               = selff.PlayerScripts;
        local HumSelf           = selc and FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf and HumSelf.RootPart;

        local ClientCon         = GG.Configs.Client.Client;
        local SilentAimCon      = GG.Configs.SilentAim;
        local AimbotCon         = GG.Configs.Aimbot;
        local ESPCon            = GG.Configs.ESP;
        local ESPObjects        = GG.ESPObjects;

        local dist              = CommonF.dist;
        local WToView           = Cam.WorldToViewportPoint;

        local GInterface        = WaitForChild(PSG, "Game Interface", 9e9);

        local PStart            = WaitForChild(PSS, "Start", 9e9);
        local SGame             = WaitForChild(PStart, "Game", 9e9);

        local RCommon           = WaitForChild(R, "Common", 9e9);
        local RPackets          = WaitForChild(RCommon, "Packets", 9e9);

        local WeaponClient      = require(WaitForChild(SGame, "WeaponClient", 9e9));
        local WeaponPackets     = require(WaitForChild(RPackets, "WeaponPackets", 9e9));
        table.foreach(CircleF,print)
        local AimbotCir         = CircleF:new(AimbotCon["Circle Size"]);
        
        local RE                = {ByteNetReliable=WaitForChild(R, "ByteNetReliable", 9e9)};
        local RaycastIgnoreList = {Cam, nil, nil}
        local Functions         = {randomObjs={"Head", "HumanoidRootPart"}};

        local params = RaycastParams.new();
        params.FilterType = Enum.RaycastFilterType.Exclude;
        params.IgnoreWater = true;

        Functions.InitializeGC = IB_NO_VIRTUALIZE(function()
            local old = false; old = GG.LowerC(WeaponPackets.useWeapon.send,function(packet)
                if GTarget and selc then
                    local head = FindFirstChild(selc, "Head");
                    if head then
                        local origin = head.Position;
                        local targetPos = GTarget.Position;
                        local direction = (targetPos - origin).Unit;
                        packet.origin = origin;
                        packet.direction = direction;
                        packet.position = targetPos;
                        packet.hitPart = GTarget;
                        packet.hitResult = FindFirstAncestorOfClass(GTarget, "Model");
                        packet.was360 = true;
                        packet.quickscope = true;
                    end;
                end; return old(packet)
            end);
            local o;o=GG.LowerC(WeaponClient.getBullets, function(...)
                if ClientCon["No Reload"] then
                    return 10;
                end; return o(...);
            end);
        end);
        Functions.Respawn = IB_NO_VIRTUALIZE(function()
            if not GInterface.Deathscreen.Visible then return; end;
            RE.ByteNetReliable:FireServer(buffer.fromstring("\027\001"))
        end);
        Functions.Spin = IB_NO_VIRTUALIZE(function(bool, num)
            if not HumRSelf or not HumRSelf.Parent then return; end;
            if bool and FindFirstChild(HumRSelf, "SPIN_AB") then return; end;
            local chs = GetChildren(HumRSelf); for i=1, #chs do
                local v = chs[i]; if v and v.Name == "SPIN_AB" then
                    v:Destroy();
                end;
            end; if not bool then return; end;
            num = tonumber(num) or 50;
            local Spin = Instancen("BodyAngularVelocity");
            Spin.Name = "SPIN_AB"; Spin.Parent = HumRSelf;
            Spin.MaxTorque = VEC0M0;
            if not VECNUM[num] then
                VECNUM[num] = Vec3(0,num,0);
            end; Spin.AngularVelocity = VECNUM[num];
        end);
        Functions.UpdateSpinSpeed = IB_NO_VIRTUALIZE(function(num)
            num = tonumber(num) or 50;
            if not HumRSelf or not HumRSelf.Parent then return; end;
            local SPIN_AB = FindFirstChild(HumRSelf, "SPIN_AB");
            if not SPIN_AB then return; end; if not VECNUM[num] then
                VECNUM[num] = Vec3(0,num,0);
            end; local chs = GetChildren(HumRSelf); for i=1, #chs do
                local v = chs[i]; if v and v.Name == "SPIN_AB" then
                    v.AngularVelocity = VECNUM[num];
                end;
            end;
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
            return self.isWall(camPos, HumR, {Cam, HumR.Parent, selc});
        end);
        Functions.getNearestPlayer = IB_NO_VIRTUALIZE(function(self)
            local Target = if SilentAimCon.Target == "Random" then self.randomObjs[math.random(1, #self.randomObjs)] else SilentAimCon.Target;
            if not selc or not selc.Parent or not FindFirstChild(selc, Target) then
                return nil;
            end;  local camPos = Cam.CFrame.Position;
            local nearestTarget, shortestDistance = nil, math.huge;
            local PlayersList = GetChildren(W); for i = 1, #PlayersList do
                local targetCharacter = PlayersList[i];
                if (SilentAimCon.SelfShot and targetCharacter == selc) or targetCharacter ~= selc then
                    if IsA(targetCharacter, "Model") then
                        local Hum = targetCharacter and FindFirstChildOfClass(targetCharacter, "Humanoid");
                        local root = targetCharacter and FindFirstChild(targetCharacter, Target);
                        if root and Hum and Hum.Health > 0 then
                            if self.IsInSight(self, root) then
                                local distance = dist(root.Position);
                                if distance < shortestDistance then
                                    shortestDistance = distance;
                                    nearestTarget = targetCharacter;
                                end;
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
            local MousePos = GetMouseLocation(UserInputService);
            local RequiredDistance = AimbotCon["Circle Size"];
            if not AimbotTarget then
                local Mob=GetChildren(W);
                 for i=1, #Mob do
                    local v = Mob[i]; v = v and v.Parent and v; if v ~= nil and v ~= selc and selc and IsA(v, "Model") then
                        local TargetPart = v and FindFirstChild(v, AimbotCon.Target);
                        local Hum = FindFirstChildOfClass(v, "Humanoid");
                        if TargetPart and Hum and Hum.Health > 0 then
                            local Vector, OnScreen = WToView(Cam, TargetPart.Position);
                            local Distance = (Vec2(MousePos.X, MousePos.Y) - Vec2(Vector.X, Vector.Y)).Magnitude;
                            local HasClear = false;
                            pcall(function()
                                RaycastIgnoreList[2] = TargetPart.Parent;
                                RaycastIgnoreList[3] = selc;
                                if not self.isWall(Cam.CFrame.Position, TargetPart, RaycastIgnoreList) then
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
                local Vector, OnScreen = TargetPart and WToView(Cam, TargetPart.Position);
                if not TargetPart or not Hum or Hum.Health <= 0 then
                    return self.CancelAimbot(Circle);
                elseif (Vec2(MousePos.X, MousePos.Y) - Vec2(Vector.X, Vector.Y)).Magnitude > RequiredDistance then
                    return self.CancelAimbot(Circle);
                end;
            end;
        end);
        Functions.ESPPlayers = IB_NO_VIRTUALIZE(function()
            local Mobs = GetChildren(W);
            for i=1, #Mobs do
                local v = Mobs[i]; v = v and v.Parent and v;
                if v and v ~= selc and v.Parent and IsA(v, "Model") then
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
            local PlayersList = GetChildren(W); 
            local lineIndex = 1;
            for i=1, #PlayersList do
                local char = PlayersList[i];
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
            ClientTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Third Person", EN2="Change the camera perspective to third person.", TH1="มุมมองบุคคลที่ 3", TH2="สลับมุมมองเป็นแบบบุคคลที่ 3", Path="Client/Third Person", Bindable="+", Callback=IB_NO_VIRTUALIZE(function(state)
                            ClientCon.ThirdPerson = state;
                            if not state then
                                selff.CameraMode = Enum.CameraMode.LockFirstPerson;
                                selff.CameraMaxZoomDistance = 0.5;
                                selff.CameraMinZoomDistance = 0.5;
                            else
                                selff.CameraMode = Enum.CameraMode.Classic;
                                selff.CameraMaxZoomDistance = 128;
                                selff.CameraMinZoomDistance = 10;
                            end;
                        end)},
                        {type="Toggle", EN="Auto Respawn", EN2="Turns on auto respawn.", TH1="ออโต้เกิดใหม่", TH2="เปิดใช้งานออโต้เกิดใหม่", Bindable="+", Path="Client/AutoRespawn"},
                        {type="Toggle", EN="No Reload", EN2="Turns off reloading.", TH1="ปิดใช้งานการรีโหลด", TH2="ปิดใช้งานการรีโหลดปืน", Path="Client/No Reload"},
                        {type="Toggle", EN="Spin", EN2="Spin your character.", TH1="หมุน", TH2="หมุนตัวละคร", Path="Client/Spin"},
                        {type="Slider", EN="Spin Speed", EN2="Change the speed of the spin.", TH1="ความเร็วในการหมุน", TH2="ปรับความเร็วในการหมุน", Value={Min=1, Max=100}, Step=1, Path="Client/Spin Speed"},
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                        {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="ลอย", TH2="ทำให้ตัวละครเดินบนอากาศได้", Path="Client/Float"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                    }, Title="Client", Open=true};
                }};
            };
            SilentAimTab = {
                {type="Paragraph", EN="Wall Check & Look Direction", EN2="These 2 are forced use by the script due to Anti Cheat. These won't be show in the setting.", TH1="เช็คกำแพง & ทิศทางที่มอง", TH2="สองอย่างนี้สคริปจะบังคับใช้เนื่องจากกันโปร 2อย่างนี้จะไม่แสดงในการตั้งค่า"},
                {type="Dropdown", EN="Target", EN2="Select where the script should aim at.", TH1="เป้าหมาย", TH2="เลือกจุดที่สคริปควรเล็ง", Values={"Head", "HumanoidRootPart"}, Path="Target"},
                {type="Toggle", EN="Self-Shot", EN2="Allow you to shoot at your own character.", TH1="ยิงตัวเอง", TH2="แปลกดีเนอะ แต่มันได้แต้ม5555", Path="SelfShot"},
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

        CoruTask.New("Spin", IB_NO_VIRTUALIZE(function()
            while true do
                if not ClientCon.Spin or CoreDestroyed then
                    Functions.Spin(false);
                    CoruTask.Close("Spin");
                end; Functions.Spin(ClientCon.Spin, ClientCon["Spin Speed"]);
                Functions.UpdateSpinSpeed(ClientCon["Spin Speed"]);
                twait(0.1);
            end;
        end));

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
                Title = "[FPS] OneTap",
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
        end; local LSecureLoad = function()
            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false;
                AimbotCir:SetColor(RED); AimbotCir:SetThickness(2);
                
                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if SilentAimCon.Enable then
                            local char = Functions:getNearestPlayer();
                            if char then
                                local Hitbox = FindFirstChild(char, "Hitbox");
                                GTarget = Hitbox and FindFirstChild(Hitbox, "Hitbox_Head");
                                if GTarget and SilentAimCon["Auto Fire"] and oclock() - TimerC >= 0.25 then
                                    TimerC = oclock(); mouse1click();
                                end;
                            else
                                GTarget = nil;
                            end;
                        end; if ESPCon.Players then
                            CoruTask.Handle("ESP");
                        end; if ClientCon.Spin then
                            CoruTask.Handle("Spin");
                        end; if ClientCon.AutoRespawn then
                            Functions.Respawn();
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

                    ClientPackage.UpdatePosition(ClientCon.Float, ForceFloat, HumRSelf);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
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
                CoreConnection[4] = GG.H.Heartbeat:Connect(IB_NO_VIRTUALIZE(function(delta)
                    if CoreDestroyed and CoreConnection[4] then
                        CoreConnection[4]:Disconnect(); CoreConnection[4] = nil;
                        return;
                    end;

                    if ClientCon["Enable TeleportWalk"] and selc and HumSelf and HumSelf.MoveDirection.Magnitude > 0 then
                        selc:TranslateBy(HumSelf.MoveDirection * ClientCon["TeleportWalk Speed"] * delta * 10);
                    end;
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
