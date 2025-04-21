
-- // Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- // Aimbot Settings
local AimbotEnabled = false
local AimbotKey = Enum.KeyCode.E -- Key to toggle
local AimbotFOV = 150
local TargetPart = "Head"

-- // Create GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "AimbotGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "⚙️ Aimbot Menu"
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 40)
ToggleBtn.Text = "Aimbot: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.TextSize = 14

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 14

-- // Toggle Aimbot
ToggleBtn.MouseButton1Click:Connect(function()
	AimbotEnabled = not AimbotEnabled
	ToggleBtn.Text = AimbotEnabled and "Aimbot: ON ✅" or "Aimbot: OFF ❌"
end)

CloseBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- // Function to get closest player to mouse
local function GetClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = AimbotFOV

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP and player.Character and player.Character:FindFirstChild(TargetPart) then
			local partPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character[TargetPart].Position)
			if onScreen then
				local dist = (Vector2.new(partPos.X, partPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
				if dist < shortestDistance then
					shortestDistance = dist
					closestPlayer = player
				end
			end
		end
	end

	return closestPlayer
end

-- // Aimbot Loop
RS.RenderStepped:Connect(function()
	if AimbotEnabled then
		local target = GetClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild(TargetPart) then
			local targetPart = target.Character[TargetPart]
			local cam = workspace.CurrentCamera
			cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
		end
	end
end)

-- // Toggle Aimbot
ToggleBtn.MouseButton1Click:Connect(function()
	AimbotEnabled = not AimbotEnabled
	ToggleBtn.Text = AimbotEnabled and "ChatFilter: ON ✅" or "ChatFilter: OFF ❌"
end)

local TCS = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local RStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local isLegacy = TCS.ChatVersion == Enum.ChatVersion.LegacyChatService
local ChatBar = CoreGui:FindFirstChild("TextBoxContainer", true) or PlayerGui:FindFirstChild("Chat"):FindFirstChild("ChatBar", true)
ChatBar = ChatBar:FindFirstChild("TextBox") or ChatBar

local Keywords = {
    {"you fucking retard", "yo⁥⁥⁥⁥⁥⁥uf⁥⁥⁥⁥⁥⁥⁥⁥⁥u⁥⁥⁥⁥⁥⁥⁥⁥⁥c⁥⁥⁥⁥⁥⁥⁥⁥⁥k⁥⁥i⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥n⁥gr⁥⁥⁥⁥⁥⁥e⁥⁥t⁥⁥⁥⁥⁥⁥ar⁥⁥⁥⁥⁥⁥d"},
    {"shut up faggot and die", "s⁥⁥⁥⁥⁥⁥⁥⁥һu⁥⁥⁥⁥⁥⁥⁥⁥tu⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥pf⁥⁥⁥⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ɡɡ⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥o⁥⁥⁥⁥⁥⁥⁥⁥tan⁥⁥⁥⁥⁥⁥⁥⁥ddi⁥⁥⁥⁥⁥⁥⁥⁥е"},
    {"you fucking nigger", "yоufu⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥сk⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥іn⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥gn⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ggе⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥r"},
    {"fucking nigger", "fu⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥сk⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥іn⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥gn⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ggе⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥r"},
    {"shut up nigger and die", "s⁥⁥⁥⁥⁥⁥⁥⁥һu⁥⁥⁥⁥⁥⁥⁥⁥tu⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥pn⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ggе⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ran⁥⁥⁥⁥⁥⁥⁥⁥ddi⁥⁥⁥⁥⁥⁥⁥⁥е"},
    {"lil nigga", "li⁥⁥⁥⁥⁥⁥⁥⁥⁥ӏn⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ggа"},
    {"fucking", "fu⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥сk⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥іn⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥g"},
    {"nigger", "n⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ggе⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥r"},
    {"faggot", "f⁥⁥⁥⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ɡɡ⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥o⁥⁥⁥⁥⁥⁥⁥⁥t"},
    {"nigga", "n⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥ggа"},
    {"fuck", "fu⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥сk"},
    {"retard", "r⁥⁥⁥⁥⁥⁥e⁥⁥t⁥⁥⁥⁥⁥⁥ar⁥⁥⁥⁥⁥⁥d"},
    {"up", "u⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥p"},
    {"shut", "s⁥⁥⁥⁥⁥⁥⁥⁥һu⁥⁥⁥⁥⁥⁥⁥⁥t"},
    {"child porn", "ch⁥⁥⁥⁥⁥⁥⁥⁥⁥iӏdpо⁥⁥⁥⁥⁥⁥⁥⁥⁥rn"},
    {"butt", "butt"},
    {"snapchat", "ѕnарсһаt"},
    {"snap", "ѕnар"},
    {"instagram", "іnѕtаgrаm"},
    {"insta", "іnѕtа"},
    {"dirty", "dіrtу"},
    {"rape", "⁥⁥⁥⁥⁥r⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥р⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥"},
    {"sex", "⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥х⁥⁥⁥⁥⁥"},
    {"whore", "⁥⁥⁥⁥⁥w⁥⁥⁥⁥⁥һ⁥⁥⁥⁥⁥o⁥⁥⁥⁥⁥r⁥⁥⁥⁥⁥e⁥⁥⁥⁥⁥"},
    {"slut", "⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥ӏ⁥⁥⁥⁥⁥u⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥"},
    {"pornhub", "⁥⁥⁥⁥⁥ро⁥⁥⁥⁥⁥r⁥⁥⁥⁥⁥n⁥⁥⁥⁥⁥һ⁥⁥⁥⁥⁥u⁥⁥⁥⁥⁥b⁥⁥⁥⁥⁥"},
    {"cock", "cо⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥⁥сk"},
    {"pussy", "⁥⁥⁥⁥⁥р⁥⁥⁥⁥⁥u⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥у⁥⁥⁥⁥⁥"},
    {"naked", "⁥⁥⁥⁥⁥n⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥k⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥d⁥⁥⁥⁥⁥"},
    {"titties", "⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥"},
    {"titty", "⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥y⁥⁥⁥⁥⁥"},
    {"tits", "⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥t⁥⁥⁥⁥⁥s⁥⁥⁥⁥⁥"},
    {"cum", "⁥⁥⁥⁥⁥с⁥⁥⁥⁥⁥u⁥⁥⁥⁥⁥m⁥⁥⁥⁥⁥"},
    {"kkk", "⁥⁥⁥⁥⁥К⁥⁥⁥⁥⁥К⁥⁥⁥⁥⁥К⁥⁥⁥⁥⁥"},
    {"rizz", "r⁥⁥⁥⁥⁥i⁥⁥⁥⁥⁥z⁥⁥⁥⁥⁥z"},
    {"ass", "⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥"},
    {"vagina", "⁥⁥⁥⁥⁥v⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥g⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥n⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥"},
    {"nudes", "⁥⁥⁥⁥⁥n⁥⁥⁥⁥⁥u⁥⁥⁥⁥⁥d⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥"},
    {"ho", "⁥⁥⁥⁥⁥һ⁥⁥⁥⁥⁥о⁥⁥⁥⁥⁥"},
    {"blowjob", "⁥⁥⁥⁥b⁥⁥⁥⁥ӏ⁥⁥⁥⁥о⁥⁥⁥⁥w⁥⁥⁥⁥ј⁥⁥⁥⁥o⁥⁥⁥⁥b⁥⁥⁥⁥"},
    {"femboy", "fеmbоу"},
    {"love", "⁥⁥⁥⁥⁥ӏ⁥⁥⁥⁥⁥о⁥⁥⁥⁥⁥v⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥"},
    {"kiss", "⁥⁥⁥⁥⁥k⁥⁥⁥⁥⁥і⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥"},
    {"discord", "dіѕсоrd"},
    {"porn", "⁥⁥⁥⁥⁥ро⁥⁥⁥⁥⁥r⁥⁥⁥⁥⁥n⁥⁥⁥⁥⁥"},
    {"damn", "dаmn"},
    {"anal", "аnаl"},
    {"zoophile", "zоорһіӏе"},
    {"lmao", "LМАО"},
    {"lmfao", "LМFАО"},
    {"george", "gеоrgе"},
    {"floyd", "flоуd"},
    {"sexual", "⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥х⁥⁥⁥⁥⁥ual"},
    {"tiktok", "tіktоk"},
    {"twerk", "twеrk"},
    {"gay", "⁥⁥⁥⁥⁥g⁥⁥⁥⁥⁥а⁥⁥⁥⁥⁥у⁥⁥⁥⁥⁥"},
    {"black", "bӏасk"},
    {"suck", "ѕuсk"},
    {"heil", "һеіӏ"},
    {"nazi", "⁥⁥⁥⁥⁥n⁥⁥⁥⁥⁥a⁥⁥⁥⁥⁥z⁥⁥⁥⁥⁥ⅰ⁥⁥⁥⁥⁥"},
    {"penis", "⁥⁥⁥⁥⁥р⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥п⁥⁥⁥⁥⁥ⅰ⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥"},
    {"sperm", "⁥⁥⁥⁥⁥ѕ⁥⁥⁥⁥⁥р⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥г⁥⁥⁥⁥⁥m⁥⁥⁥⁥⁥"},
    {"pedo", "⁥⁥⁥⁥⁥р⁥⁥⁥⁥⁥е⁥⁥⁥⁥⁥ɗ⁥⁥⁥⁥⁥о⁥⁥⁥⁥⁥"},
    {"hate", "һаtе"},
    {"balls", "bаӏӏѕ"},
    {" ", ""}
}

local Gen = function(Message)
    for _, info in Keywords do
        local real = info[1]
        local bypass = info[2]
        Message = Message:gsub(real, bypass)
    end
    return Message
end

local Connection = Instance.new("BindableFunction")

for _, c in getconnections(ChatBar.FocusLost) do
    c:Disconnect()
end

ChatBar.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        Connection:Invoke(ChatBar.Text)
        ChatBar.Text = ""
    end
end)

Connection.OnInvoke = function(Message)
    Message = Gen(Message)
    if isLegacy then
        local ChatRemote = RStorage:FindFirstChild("SayMessageRequest", true)
        ChatRemote:FireServer(Message, "All")
    else
        local Channel = TCS.TextChannels.RBXGeneral
        Channel:SendAsync(Message)
    end
end

local NotifyModule = {}

if not NotifyGui then
    getgenv().NotifyGui = Instance.new("ScreenGui")
    getgenv().Template = Instance.new("TextLabel")
    
    if syn then
        if gethui then
            gethui(NotifyGui)
        else
            syn.protect_gui(NotifyGui)
        end
    end
    
    NotifyGui.Name = "Notification"
    NotifyGui.Parent = CoreGui
    
    Template.Name = "Template"
    Template.Parent = NotifyGui
    Template.AnchorPoint = Vector2.new(.5, .5)
    Template.BackgroundTransparency = 1
    Template.BorderSizePixel = 0
    Template.Position = UDim2.new(.5, 0, 1.5, 0)
    Template.Size = UDim2.new(.8, 0, .1, 0)
    Template.Font = Enum.Font.Code
    Template.Text = ""
    Template.TextSize = 30
    Template.TextWrapped = true
end

local Tween = function(Object, Time, Style, Direction, Property)
    return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
end

function NotifyModule:Notify(Text, Duration)
    task.spawn(function()
        local Clone = Template:Clone()
        Clone.Name = "ClonedNotification"
        Clone.Parent = NotifyGui
        Clone.Text = Text
        Clone.TextColor3 = Color3.fromRGB(75, 121, 233)

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Parent = Clone
        UIStroke.Thickness = 1
        UIStroke.Transparency = 0.5
        
        if not Duration or Duration == nil then
    	    Duration = 5
        end
    	
        local FinalPosition = 0
        
        for _, x in next, NotifyGui:GetChildren() do
            if x.Name ~= "Template" then
                FinalPosition += .125
            end
        end
        
        local TweenPos = Tween(Clone, 1, "Quart", "InOut", {Position = UDim2.new(.5, 0, .95 - FinalPosition, 0)})
        TweenPos:Play()
        TweenPos.Completed:wait()
        
        wait(Duration)
        
        TweenPos = Tween(Clone, 1, "Quart", "InOut", {Position = UDim2.new(.5, 0, 1.5, 0)})
        TweenPos:Play()
        TweenPos.Completed:wait()
        
        Clone:Destroy()
    end)
end

NotifyModule:Notify("heartasian's bypass loaded ► press 0 to join discord for more exclusive scripts", 5)

local Connection
Connection = UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE or Input.KeyCode ~= Enum.KeyCode.Zero then return end

    NotifyModule:Notify("copied invite link to clipboard")
    setclipboard("https://discord.com/invite/FRsmP9knVc")
    Connection:Disconnect()
end)
