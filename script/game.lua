package.path = package.path .. ";C:/Projects/Galagus/scripts/?.lua"
--require("debugging")
require("keyCodes")
require("gamepadCodes")
require("starfield")
require("menuStars")
require("explosions")
require("player")
require("enemy")
require("gui")
require("gameplay")

local logo = {}
local logoRot = 0.0

function Startup()
	-- TODO: seed the random number generator
	io.write("Game started\n")

    --DebuggingStartup(true)
  
	-- Initialise the game components
	StarfieldStartup()
	MenuStarfieldStartup()
	EnemyStartup()
	PlayerStartup()
	ExplosionsStartup()
	GameplayStartup()
	GUIStartup()

	logo.gameObject = GameObject:Get("logo");
 
	-- Main game loop
	while Update() do 
		Yield()
	end

	Shutdown()
end

function Update()  
	-- Update the simulation
	local frameDt = GetFrameDelta()
	GameplayUpdate()
	GUIUpdate()

	if GameplayIsMenuState() then
		MenuStarfieldUpdate()

		logoRot = logoRot + frameDt * 3.0
		logo.gameObject:SetRotation(0.0, 0.0, math.sin(logoRot) * 20.0)
	elseif GameplayIsGameState() then
		StarfieldUpdate()
		EnemyUpdate()
		PlayerUpdate()
		ExplosionsUpdate()
	end
	
	return true
end

function Shutdown()
	StarfieldShutdown()
	io.write("Game shutdown.\n")
end

Startup()

--[[ Engine Reference follows

Global Functions
----------------
dt = GetFrameDelta()
SetCameraPosition(x, y, z)
SetCameraRotation(x, y, z)
SetCameraFOV(f)
MoveCamera(x,y,z)
RotateCamera(x,y,z)
NewScene("newSceneName")
SetScene("existingSceneName")
bool = IsKeyDown(keyCodes.character)
bool = IsGamePadConnected(padId)
bool = IsGamePadButtonDown(padId, buttonId)
x,y = GetGamePadLeftStick(padId)
x,y = GetGamePadRightStick(padId)
f = GetGamePadLeftTrigger(padId)
f = GetGamePadRightTrigger(padId)
DebugPrint("A string to be displayed in a box on screen for one frame")
DebugLog("A string to be printed into the log")
DebugLine(x1, y1, z1, x2, y2, z2)
obj = GameObject:Create("templateName")
obj = GameObject:Create("templateName", "sceneName")

GUI Functions
-------------
GUI:SetValue("widgetName", "value")
string = GUI:GetValue("widgetName")
GUI:Show("widgetName")
GUI:Hide("widgetName")
GUI:Activate("widgetName")
string = GUI:GetSelected()
GUI:SetSelected("widgetName")
GUI:SetActiveMenu("MenuName")
GUI:EnableMouse()
GUI:DisableMouse()

GameObject Functions
--------------------
i = myGameObject:GetId()
string = myGameObject:GetName()
myGameObject:SetName("New Name")
x,y,z = myGameObject:GetPosition()
myGameObject:SetPosition(x, y, z)
x,y,z = myGameObject:GetRotation()
myGameObject:SetRotation(x, y, z)
f = myGameObject:GetScale()
myGameObject:SetScale(x, y, z)
f = myGameObject:GetLifeTime()
myGameObject:SetLifeTime(newLifeTime)
myGameObject:SetSleeping()
myGameObject:SetActive()
bool = myGameObject:IsSleeping()
bool = myGameObject:IsActive()
myGameObject:EnableCollision()
myGameObject:DisableCollision()
bool = myGameObject:HasCollisions()
{} = myGameObject:GetCollisions()
myGameObject:PlayAnimation("AnimationName")
myGameObject:Destroy()
]]