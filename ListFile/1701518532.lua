local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[Plasma Hub] : Really? Your account is now at risk for the next ban wave."); end;

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

GG.Configs = GG.Configs or {
    ["Client"] = {
        ["Client"] = {};
    },
};

return {
    Version = "JPJ_V3.01";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, CoruTask, ESPPackage, CommonF)
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

        local Functions = {};

        Functions.GiveWeldRope = IB_NO_VIRTUALIZE(function()
            local Tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool"):Clone();
            Tool.Name = "WeldRope"
            Tool.Parent = game.Players.LocalPlayer.Backpack

            -- Services
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local UserInputService = game:GetService("UserInputService")

            -- Modules
            local Shared = ReplicatedStorage:WaitForChild("_Shared")
            local Core = Shared:WaitForChild("_Core")
            local Network = Shared:WaitForChild("_Network")

            require(Core:WaitForChild("AdminToolManager"))

            local Networks = require(Network:WaitForChild("Networks"))

            -- Player
            local LocalPlayer = Players.LocalPlayer
            local Camera = workspace.CurrentCamera

            -- Controls
            local Controls = require(
                LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
            ):GetControls()

            -- Remote
            local WeldRopeRemote = Networks.AdminTool.WeldRope

            -- Flight State
            local Flying = false
            local FlightConnection
            local FlightAttachment
            local VelocityController
            local OrientationController

            ---------------------------------------------------------------------
            -- Start Flight
            ---------------------------------------------------------------------

            local function startFlight(character)

                local root = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if not (root and humanoid) then
                    return
                end

                local animator = humanoid:FindFirstChildOfClass("Animator")

                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end

                humanoid.PlatformStand = true
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)

                FlightAttachment = Instance.new("Attachment")
                FlightAttachment.Name = "FlightAttachment"
                FlightAttachment.Parent = root

                VelocityController = Instance.new("LinearVelocity")
                VelocityController.Attachment0 = FlightAttachment
                VelocityController.MaxForce = math.huge
                VelocityController.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                VelocityController.RelativeTo = Enum.ActuatorRelativeTo.World
                VelocityController.Parent = root

                OrientationController = Instance.new("AlignOrientation")
                OrientationController.Attachment0 = FlightAttachment
                OrientationController.Mode = Enum.OrientationAlignmentMode.OneAttachment
                OrientationController.MaxTorque = math.huge
                OrientationController.Responsiveness = 200
                OrientationController.Parent = root

                local currentVelocity = Vector3.zero

                FlightConnection = RunService.RenderStepped:Connect(function(dt)

                    if not Flying or humanoid.Health <= 0 then
                        return
                    end

                    local moveVector = Controls:GetMoveVector()

                    local vertical =
                        UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1
                        or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0)

                    local targetVelocity

                    if moveVector.Magnitude > 0 or vertical ~= 0 then

                        local look = Camera.CFrame.LookVector
                        local right = Camera.CFrame.RightVector

                        local direction =
                            look * -moveVector.Z +
                            right * moveVector.X +
                            Vector3.new(0,1,0) * vertical

                        if direction.Magnitude > 1 then
                            direction = direction.Unit
                        end

                        targetVelocity = direction * 50

                    else
                        targetVelocity = Vector3.zero
                    end

                    currentVelocity = currentVelocity:Lerp(targetVelocity, 5 * dt)

                    VelocityController.VectorVelocity = currentVelocity

                    OrientationController.CFrame =
                        CFrame.new(Vector3.zero, Camera.CFrame.LookVector)

                end)
            end

            ---------------------------------------------------------------------
            -- Stop Flight
            ---------------------------------------------------------------------

            local function stopFlight(character)

                if FlightConnection then
                    FlightConnection:Disconnect()
                    FlightConnection = nil
                end

                if VelocityController then
                    VelocityController:Destroy()
                end

                if OrientationController then
                    OrientationController:Destroy()
                end

                if FlightAttachment then
                    FlightAttachment:Destroy()
                end

                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.PlatformStand = false
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end

            ---------------------------------------------------------------------
            -- Mouse Target Player
            ---------------------------------------------------------------------

            local function getMousePlayer()

                local mousePos = UserInputService:GetMouseLocation()

                local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)

                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances = { LocalPlayer.Character }

                local result = workspace:Raycast(ray.Origin, ray.Direction * 200, params)

                if not result or not result.Instance then
                    return nil, nil
                end

                local model = result.Instance:FindFirstAncestorOfClass("Model")

                local player =
                    model
                    and model:FindFirstChildOfClass("Humanoid")
                    and Players:GetPlayerFromCharacter(model)

                return player, model
            end

            ---------------------------------------------------------------------
            -- Tool Equipped
            ---------------------------------------------------------------------

            Tool.Equipped:Connect(function()

                Flying = true

                local character = LocalPlayer.Character

                if character then
                    startFlight(character)
                end
            end)

            ---------------------------------------------------------------------
            -- Tool Unequipped
            ---------------------------------------------------------------------

            Tool.Unequipped:Connect(function()

                Flying = false

                local character = LocalPlayer.Character

                if character then
                    stopFlight(character)
                end
            end)

            ---------------------------------------------------------------------
            -- Tool Activated
            ---------------------------------------------------------------------

            Tool.Activated:Connect(function()

                if not Flying then
                    return
                end

                local _, targetCharacter = getMousePlayer()

                if targetCharacter then
                    WeldRopeRemote:Fire("Tether", targetCharacter)
                else
                    WeldRopeRemote:Fire("Release")
                end
            end)
        end);

        local ScriptData = {
            AutoData = {
                ClientTab = {
                    {type="Group", dats={
                        {dat={
                            {type="Button", EN="Give WeldRope", EN2="Allow you to fly", TH1="ไม่รู้ บินมั้ง", TH2="ไม่มีคำอธิบาย", Callback=IB_NO_VIRTUALIZE(function()
                                Functions.GiveWeldRope();
                            end)};  
                            {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                            {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="ลอย", TH2="ทำให้ตัวละครเดินบนอากาศได้", Path="Client/Float"},
                            {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="เดินทะลุกำแพง", TH2="ต้องอธิบายด้วยหรอ", Path="Client/Noclip"},
                            {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                            {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                        }, Title="Client", Open=true};
                    }};
                };
            };
        };

        local LSecureUI = function()
            local WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "Joodpakjai",
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
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function(AUTH_KEY)
            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false;

                LSecureUI();

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
