local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local Instancen = Instance.new;
local Vec3 = Vector3.new;
local Col3 = Color3;
local CF = CFrame;
local tk = task;

local twait = tk.wait;
local FindFirstChildOfClass = game.FindFirstChildOfClass;

local ScriptData = {
    AutoData = {
        ClientTab = {
            {type="Group", dats={
                {dat={
                    {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                    {type="Toggle", EN="Instant Prompt", EN2="On some prompt/maps, this can flag anti cheat so remember to turn it off when you have to.", TH1="กด Prompt เร็วขึ้น", TH2="กดพวกปุ่มที่มันขึ้นมาให้กดเร็วขึ้น (Class:Prompt)", Path="Client/Instant Prompt"},
                    {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="ลอย", TH2="ทำให้ตัวละครเดินบนอากาศได้", Path="Client/Float"},
                    {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="เดินทะลุกำแพง", TH2="ต้องอธิบายด้วยหรอ", Path="Client/Noclip"},
                    {type="Slider", EN="Walk Speed", EN2="Change the speed of your walk.", TH1="ความเร็วในการเดิน", TH2="ปรับความเร็วการเดิน", Value={Min=1, Max=100}, Path="Client/WalkSpeed"},
                    {type="Toggle", EN="Enable Walk Speed", EN2="Enable walk speed modification.", TH1="เปิดใช้งานความเร็วในการเดิน", TH2="ปรับความเร็วในการเดิน", Path="Client/Enable WalkSpeed"},
                    {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                    {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                    {type="Slider", EN="Jump Power", EN2="Change the power of your jump.", TH1="ความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Value={Min=1, Max=300}, Path="Client/JumpPower"},
                    {type="Toggle", EN="Enable Jump Power", EN2="Enable jump power modification.", TH1="เปิดใช้งานความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Path="Client/Enable JumpPower"},
                    {type="Slider", EN="Fly Speed", EN2="Change the speed of your flight.", TH1="ความเร็วในการบิน", TH2="ปรับความเร็วในการบิน", Value={Min=1, Max=10}, Path="Client/FlySpeed"},
                    {type="Toggle", EN="Enable Fly", EN2="Allow you to fly.", TH1="บิน", TH2="บินได้", Path="Client/Enable Fly"},
                }, Title="Client", Open=true};
            }};
        };
    };
};

GG.Configs = GG.Configs or {
    ["Client"] = {
        ["Client"] = {
            ["FlySpeed"] = 1,
        };
    },
};

return {
    Version = "RealUNISnapshot3";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, PromptPackage, CoruTask)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";

        local Cam               = GG.W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local selc              = selff.Character or selff.CharacterAdded:Wait();
        local HumSelf           = FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf.RootPart;

        local cmdm              = selff:GetMouse();
        local ClientCon         = GG.Configs.Client.Client;
        local Control           = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0};

        local Functions = {};

        Functions.KeyDown = function(key)
            if not ClientCon["Enable Fly"] then return; end;
            if key == "w" then Control.F =  1 * ClientCon.FlySpeed; end;
            if key == "d" then Control.R =  1 * ClientCon.FlySpeed; end;
            if key == "s" then Control.B = -1 * ClientCon.FlySpeed; end;
            if key == "a" then Control.L = -1 * ClientCon.FlySpeed; end;
        end;
        Functions.KeyUp = function(key)
            if not ClientCon["Enable Fly"] then return; end;
            if key == "w" then Control.F = 0; end;
            if key == "s" then Control.B = 0; end;
            if key == "a" then Control.L = 0; end;
            if key == "d" then Control.R = 0; end;
        end;

        CoruTask.New("Fly", function()
            local BG = Instancen("BodyGyro", HumRSelf);
            local BV = Instancen("BodyVelocity", HumRSelf);
            local FSpeed = 0; while true do
                if not ClientCon["Enable Fly"] or CoreDestroyed then
                    Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0};
                    FSpeed = 0; BG:Destroy(); BV:Destroy(); CoruTask.Close("Fly");
                end; if not BG or not BG.Parent then
                    BG = Instancen("BodyGyro", HumRSelf);
                    BV = Instancen("BodyVelocity", HumRSelf);
                    BG.P = 9e4; BG.CFrame = HumRSelf.CFrame;
                    BV.MaxForce = Vec3(9e9, 9e9, 9e9);
                    BG.MaxTorque = Vec3(9e9, 1e9, 9e9);
                    BV.Velocity = Vector3.zero;
                end; if isMobile then
                    local direction = controlModule:GetMoveVector();
                    Control.L = direction.X < 0 and -1 * ClientCon.FlySpeed or 0;
                    Control.R = direction.X > 0 and  1 * ClientCon.FlySpeed or 0;
                    Control.F = direction.Z < 0 and  1 * ClientCon.FlySpeed or 0;
                    Control.B = direction.Z > 0 and -1 * ClientCon.FlySpeed or 0;

                    if Control.R ~= 0 then
                        BV.Velocity = BV.Velocity + Cam.CFrame.RightVector * (Control.R * 50);
                    end
                    if Control.L ~= 0 then
                        BV.Velocity = BV.Velocity + Cam.CFrame.RightVector * (Control.L * 50);
                    end
                    if Control.B ~= 0 then
                        BV.Velocity = BV.Velocity - Cam.CFrame.LookVector * (-Control.B * 50);
                    end
                    if Control.F ~= 0 then
                        BV.Velocity = BV.Velocity - Cam.CFrame.LookVector * (-Control.F * 50);
                    end
                    if Control.R == 0 and Control.L == 0 and Control.F == 0 and Control.B == 0 then
                        BV.Velocity = Vector3.zero;
                    end;
                else
                    if (Control.L + Control.R) ~= 0 or (Control.F + Control.B) ~= 0 or (Control.Q + Control.E) ~= 0 then
                        FSpeed = 50;
                    elseif not (Control.L + Control.R ~= 0 or Control.F + Control.B ~= 0 or (Control.Q + Control.E) ~= 0) and FSpeed ~= 0 then
                        FSpeed = 0;
                    end;
                    if (Control.L + Control.R) ~= 0 or (Control.F + Control.B) ~= 0 or (Control.Q + Control.E) ~= 0 then
                        BV.Velocity = ((Cam.CFrame.LookVector * (Control.F + Control.B)) + 
                            ((Cam.CFrame * CF.new(Control.L + Control.R, 
                            (Control.F + Control.B + Control.Q + Control.E) * 0.2, 0).p) - 
                            Cam.CFrame.p)) * FSpeed;
                    else
                        BV.Velocity = Vector3.zero;
                    end;
                end; twait(0.1);
            end;
        end);

        local LSecureUI = function()
            local WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "Universal",
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
                Welcome = Window:Tab({ Title = "Welcome", Icon = "smile" }),
                Client = LoaderSettings.AllowClientTab and Window:Tab({ Title = "Client", Icon = "user" }),

                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);
            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
                PromptPackage.UpdateState(true);
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function(AUTH_KEY)
            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false; PromptPackage.UpdateState(false);
                ClientCon.WalkSpeed = HumSelf and HumSelf.WalkSpeed or 16;
                ClientCon.JumpPower = HumSelf and HumSelf.JumpPower or 50;

                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if ClientCon["Enable Fly"] then
                            CoruTask.Handle("Fly");
                        end; twait(0.1);
                    end;
                end));

                CoreConnection[1] = GG.H.Stepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[1] then
                        CoreConnection[1]:Disconnect(); CoreConnection[1] = nil;
                        return;
                    end;

                    selc = selff.Character;
                    HumSelf = selc and FindFirstChildOfClass(selc, "Humanoid");
                    HumRSelf = HumSelf and HumSelf.RootPart;

                    ClientPackage.UpdatePosition(ClientCon.Float, ForceFloat, HumRSelf);
                    ClientPackage.Noclip(ClientCon.Noclip, selc);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
                    ClientPackage.WalkSpeedC(ClientCon["Enable WalkSpeed"], ClientCon.WalkSpeed, HumSelf);
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

                if userIdentify.device == "PC" then
                    if not ScriptCache.AlreadyCMDM then
                        ScriptCache.AlreadyCMDM = true;
                        cmdm.KeyDown:Connect(Functions.KeyDown);
                        cmdm.KeyUp:Connect(Functions.KeyUp);
                    end;
                end;

                if not CoruTask.Intialized then
                    CoruTask.Init(ScriptCache.WindUI);
                    CoruTask.Intialized = true;
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};
