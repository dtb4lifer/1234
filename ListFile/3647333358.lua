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
local unpack = tble.unpack;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local FindFirstChild = game.FindFirstChild;
local FindFirstChildOfClass = game.FindFirstChildOfClass;

local RED    = Col3.new(1, 0, 0);
local GREEN  = Col3.new(0, 1, 0);
local BLUE   = Col3.new(0, 0, 1);
local YELLOW = Col3.new(1, 1, 0);

local CFR9e9 = CFr(0, 9e9, 0);
local VEC1P5 = Vec3(1.5, 1.5, 1.5);

local ScriptData = {
    AutoData = {};
};

GG.Configs = GG.Configs or {
    ["Main"] = {
        ["Revive"] = {};
        ["Teleport"] = {};
        ["ESP"] = {};
    };
    ["Tokens"] = {};
    ["Client"] = {
        ["Client"] = {
            ["SpeedMuliplier"] = 1;
        };
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
    Version = "EvadeV3";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, CoruTask, ESPF, CommonF)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;

        local Cam               = W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local Backpack          = selff.Backpack;
        local PSG               = selff.PlayerGui;
        local selc              = selff.Character;
        local HumSelf           = selc and FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf and HumSelf.RootPart;

        local EntityCache       = {};
        local cmdm              = selff:GetMouse();
        local MainCon           = GG.Configs.Main;
        local TicketCon         = GG.Configs.Tokens;
        local ClientCon         = GG.Configs.Client.Client;

        local GGame             = WaitForChild(W, "Game", 9e9);
        local GPlayers          = WaitForChild(GGame, "Players", 9e9);
        local GEffects          = WaitForChild(GGame, "Effects", 9e9);
        local GTickets          = WaitForChild(GEffects, "Tickets", 9e9);

        local REvents           = WaitForChild(R, "Events", 9e9);
        local REPlayer          = WaitForChild(REvents, "Player", 9e9);
        local RECharacter       = WaitForChild(REvents, "Character", 9e9);

        local dist              = CommonF.dist;
        
        local Functions         = {};
        local RE = {
            Interact            = WaitForChild(RECharacter, "Interact", 9e9);
            ChangePlayerMode    = WaitForChild(REPlayer, "ChangePlayerMode", 9e9);
        };

        Functions.KeyUp = IB_NO_VIRTUALIZE(function(key)
            if key:lower() ~= "e" then return; end;
            return MainCon.Revive.Aura and Functions.ReviveAura();
        end);

        Functions.GetPDowned = IB_NO_VIRTUALIZE(function(Ps, isDBase)
            for i=1, #Ps do
                local v = Ps[i];
                if not GetAttribute(v, "Downed") then
                    continue;
                end; local HumR = v.PrimaryPart;
                if isDBase then
                    if dist(HumR.Position) <= 30 then
                        return v;
                    end;
                else
                    return true, CommonF.Tp(HumRSelf, HumR.CFrame);
                end;
            end; return nil;
        end);
        Functions.ReviveAura = IB_NO_VIRTUALIZE(function()
            local Nearest = Functions.GetPDowned(GetChildren(GPlayers), true);
            if not Nearest then return; end;
            RE.Interact:FireServer("Revive", nil, Nearest.Name);
            RE.Interact:FireServer("Revive", true, Nearest.Name);
        end);
        Functions.SelfRevive = IB_NO_VIRTUALIZE(function()
            if not HumSelf or HumSelf.Health > 0 then return; end;
            return RE.ChangePlayerMode:FireServer(true);
        end);
        Functions.TpSafeSpot = IB_NO_VIRTUALIZE(function()
            return CommonF.Tp(HumRSelf, CFR9e9);
        end);
        Functions.HTickets = IB_NO_VIRTUALIZE(function(TicketsC)
            local Tickets, Ticket = GetChildren(TicketsC), nil;
            for i=1, #Tickets do
                local HumR = Tickets[i].PrimaryPart;
                if HumR then
                    Ticket = HumR; HumR.Name = "Ticket";
                    if TicketCon.ESP and not FindFirstChild(HumR, "BoxHandleAdornment") then
                        ESPF.ESP("Tickets", HumR, BLUE, VEC1P5, false, false, false, false);
                    end;
                end;
            end; if Ticket and TicketCon.Auto then
                return true, CommonF.Tp(HumRSelf, Ticket.CFrame);
            end; return false;
        end);
        Functions.HEntities = IB_NO_VIRTUALIZE(function(Ps)
            for i = 1, #Ps do
                local v = Ps[i];
                if v == selc then continue; end;
                local HumR = v.PrimaryPart;
                if not HumR then continue; end;
                local isDowned = GetAttribute(v, "Downed");
                local isAI = GetAttribute(v, "AI");
                local Data = EntityCache[v];
                if not Data then
                    local Box, Bill;
                    if isAI and MainCon.ESP.Bots then
                        Box, Bill = ESPF.ESP("Bots", HumR, RED, Vec3(2, 3, 2), false, false);
                    elseif not isAI and MainCon.ESP.Players then
                        Box, Bill = ESPF.ESP("Players", HumR, GREEN, Vec3(2, 3, 2), false, false);
                    end;
                    Data = {Box = Box, Bill = Bill};
                    EntityCache[v] = Data;
                end;
                if Data.Box and Data.Bill then
                    local TextL = FindFirstChild(Data.Bill, "TextLabel");
                    if TextL then
                        local color = if isAI then RED elseif isDowned then YELLOW else GREEN;
                        Data.Box.Color3 = color;
                        TextL.TextColor3 = color;
                        TextL.Text = v.Name;
                    end;
                end;
            end;
        end);

        CoruTask.New("Gameplay 1", IB_NO_VIRTUALIZE(function()
            while true do
                if not MainCon.Teleport.Downed and not MainCon.Teleport.Safe and not TicketCon.Auto and not TicketCon.ESP then
                    CoruTask.Close("Gameplay 1");
                end;
                if MainCon.Teleport.Downed then
                    Functions.GetPDowned(GetChildren(GPlayers), false);
                end; if MainCon.Teleport.Safe then
                    Functions.TpSafeSpot();
                end; Functions.HTickets(GTickets);
                twait(0.05);
            end;
        end));
         CoruTask.New("Gameplay 2", IB_NO_VIRTUALIZE(function()
            while true do
                if not MainCon.Revive.Aura and not MainCon.Revive.Self then
                    CoruTask.Close("Gameplay 2");
                end;
                if MainCon.Revive.Aura then
                    Functions.ReviveAura();
                end; if MainCon.Revive.Self then
                    Functions.SelfRevive();
                end;
                twait(0.05);
            end;
        end));
        CoruTask.New("ESPs", IB_NO_VIRTUALIZE(function()
            while true do
                if not MainCon.ESP.Players and not MainCon.ESP.Bots then
                    ESPF.Destroy("Bots"); ESPF.Destroy("Players");
                    CoruTask.Close("ESPs");
                end; Functions.HEntities(GetChildren(GPlayers));
                twait(0.05);
            end;
        end));

        ScriptData.AutoData = {
            ClientTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Allow Holding", EN2="Allow you to hold spacbar/jump button.", TH1="อนุญาติการกดกระโดดค้าง", TH2="กดกระโดดค้างได้", Locked=not GG.LowerC, Path="Client/Allow Holding"},
                        {type="Slider", EN="Speed Multiplier", EN2="Change the speed of your walk.", TH1="ความเร่งในการเดิน", TH2="ปรับความเร็วการเดิน", Value={Min=1, Max=5}, Locked=not GG.LowerC, Path="Client/SpeedMuliplier"},
                        {type="Toggle", EN="Enable Speed", EN2="Enable walk speed modification.", TH1="เปิดใช้งานความเร่งในการเดิน", TH2="ปรับความเร็วในการเดิน", Locked=not GG.LowerC, Path="Client/Enable SpeedMuliplier"},
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                        {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="ลอย", TH2="ทำให้ตัวละครเดินบนอากาศได้", Path="Client/Float"},
                        {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="เดินทะลุกำแพง", TH2="ต้องอธิบายด้วยหรอ", Path="Client/Noclip"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                        {type="Slider", EN="Jump Power", EN2="Change the power of your jump.", TH1="ความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Value={Min=1, Max=300}, Path="Client/JumpPower"},
                        {type="Toggle", EN="Enable Jump Power", EN2="Enable jump power modification.", TH1="เปิดใช้งานความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Path="Client/Enable JumpPower"},
                    }, Title="Client", Open=true};
                }};
            };
            MainTab = {
                {type="Toggle", EN="Instant Revive", EN2="Revive instantly.", TH1="ชุบชีวิตทันที", TH2="ชุบชีวิตทันทีหลังจากกดชุบ", Path="Revive/Instant"},
                {type="Toggle", EN="Revive Aura", EN2="Revive nearest people.", TH1="ชุบคนใกล้ตัว", TH2="ชุบชีวิตคนใกล้ตัวอัตโนมัติ", Path="Revive/Aura"},
                {type="Toggle", EN="Auto Self-Revive", EN2="Revive yourself after you are downed.", TH1="ออโต้ชุบตัวเอง", TH2="ชุบตัวเองเวลาสดุดหญ้า", Path="Revive/Self"},
                {type="Space"},
                {type="Toggle", EN="Teleport To Safe Spot", EN2="Teleport you outside the map.", TH1="วาปไปที่ปลอดภัย", TH2="วาปไปนอกแมพ", Path="Teleport/Safe"},
                {type="Toggle", EN="Teleport To Downed Players", EN2="Teleport to downed players.", TH1="วาปไปหาคนที่ล้ม", TH2="วาปไปหาคนใกล้ตาย", Path="Teleport/Downed"},
                {type="Space"},
                {type="Toggle", EN="ESP Players", EN2="Show player's box & name.", TH1="ESP ผู้เล่น", TH2="มองเห็นชื่อและผู้เล่น", Path="ESP/Players", Callback=IB_NO_VIRTUALIZE(function(state)
                    MainCon.ESP.Players=state; ESPF.Destroy("Players");
                end)},
                {type="Toggle", EN="ESP Bots", EN2="Show bot's box & name.", TH1="ESP บอท", TH2="มองเห็นชื่อและบอท", Path="ESP/Bots", Callback=IB_NO_VIRTUALIZE(function(state)
                    MainCon.ESP.Bots=state; ESPF.Destroy("Bots");
                end)},
            };
            TokensTab = {
                {type="Toggle", EN="Auto Collect", EN2="Auto collect all tokens or tickets with auto update.", TH1="ออโต้เก็บ", TH2="วาปเก็บเหรียญหรือตั๋ว Event ต่างๆ โดยมีออโต้อัพเดต", Path="Auto"},
                {type="Toggle", EN="ESP", EN2="Show tokens and tickets in-game.", TH1="ESP เหรียญ", TH2="มองเห็นเหรียญหรือตั๋ว Event ต่างๆ", Path="ESP"},
            };
        };

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "Evade",
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
                Main = Window:Tab({Title="Main", Icon="house"}),
                Tokens = Window:Tab({Title="Tokens", Icon="ticket"}),

                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);
            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.Main, ScriptData.AutoData.MainTab, "Main");
            Windy:CreateComponent(Tabs.Tokens, ScriptData.AutoData.TokensTab, "Tokens")

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function()
            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false;
                ClientCon.WalkSpeed = HumSelf and HumSelf.WalkSpeed or 16;
                ClientCon.JumpPower = HumSelf and HumSelf.JumpPower or 50;
                
                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if MainCon.Teleport.Downed or MainCon.Teleport.Safe or TicketCon.Auto or TicketCon.ESP then
                            CoruTask.Handle("Gameplay 1");
                        end;
                        if MainCon.Revive.Aura or MainCon.Revive.Self then
                            CoruTask.Handle("Gameplay 2");
                        end;
                        if MainCon.ESP.Players or MainCon.ESP.Bots then
                            CoruTask.Handle("ESPs");
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

                    ClientPackage.UpdatePosition(ClientCon.Float, ForceFloat, HumRSelf);
                    ClientPackage.Noclip(ClientCon.Noclip, selc);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
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

                if userIdentify.device == "PC" then
                    if not ScriptCache.AlreadyCMDM then
                        ScriptCache.AlreadyCMDM = true;
                        cmdm.KeyUp:Connect(Functions.KeyUp); 
                    end;
                end;

                if not CoruTask.Intialized then
                    CoruTask.Init(ScriptCache.WindUI);
                    CoruTask.Intialized = true;

                    if GG.LowerC then
                        local InteractModule = require(R.Modules.Character.CharacterTable.CharacterController.Local.Interact.InteractChild);
                        local oldUpdate; oldUpdate = GG.LowerC(InteractModule.Update, newcclosure(function(p1, p2)
                            if not MainCon.Revive.Instant or checkcaller() then 
                                return oldUpdate(p1, p2); 
                            end; p1.Interact:Update(p2);
                            for k, v in pairs(p1.Interact.Interactions) do
                                if v.Length ~= nil then
                                    if v.Activated == true then
                                        v.Period = 1; 
                                        if v.SendToServer ~= false then
                                            RE.Interact:FireServer(v.Name, true, if p1.Interact.Child == nil then nil else p1.Interact.Child.Name);
                                            if p1.Interact.Done ~= nil then p1.Interact.Done:Play(); end;
                                        end;
                                        if p1.Interact.Use ~= nil then p1.Interact.Use:Stop(); end;
                                        v.Activated = false;
                                        v.Period = 0;
                                        continue;
                                    end;
                                    if p1.Interact.Use ~= nil then p1.Interact.Use:Stop(); end;
                                    v.Period = 0;
                                end;
                            end;
                        end));

                        local MovementValue = require(R.Modules.Character.CharacterTable.CharacterController.Local.Movement.returnValues);
                        local oldUpdate2; oldUpdate2 = GG.LowerC(MovementValue.returnSpeedChanges, newcclosure(function(_, ar)
                            if not ClientCon["Enable SpeedMuliplier"] then return oldUpdate2(_, ar); end;
                            return tonumber(ClientCon.SpeedMuliplier);
                        end));

                        local LocalMovement = require(R.Modules.Character.CharacterTable.CharacterController.Local.Movement);
                        local oldUpdate3; oldUpdate3 = GG.LowerC(LocalMovement.JumpReact, newcclosure(function(p12, p13)
                            if not ClientCon["Allow Holding"] then return oldUpdate3(p12, p13); end;
                            if p12.CanJump ~= false then
                                p12.JumpHeldDown = true;
                                p12:UpdateCanJump();
                                p12:AttemptJump();
                                if p13 ~= true then
                                    p12.CanJump = false;
                                    H.Heartbeat:wait();
                                    p12.CanJump = true;
                                end;
                            end;
                        end));
                    end;
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};
