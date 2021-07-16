local spawnTimer = 0.0
local spawnRate = 0.15
local delayTimer = 0.0
local numSpawned = 0
local level = 1
local state = 0

local enemyShotTimer = 0.0
local enemyShotRate = 1.0

local states = {
	["startup"] = 0,
	["menu"] = 1,
	["game"] = 2,
  ["death"] = 3,
  ["gameover"] = 4,
  ["win"] = 5,
	["highscore"] = 6,
}

-- Levels specify spawn sequence of enemies by home position
local levels = {
	{
		1, 2, 9, 10, 20, 21, 29, 30, "smallDelay",
		11, 19, 12, 18, 13, 17, 16, 14, 15, "smallDelay",
		3, 4, 7, 8, 22, 23, 27, 28, "smallDelay",
		5, 6, 24, 25, 26, 41, 42, 43, 50, "smallDelay",
		44, 45, 46, 47, 48, 49
	},
	{
		1, 2, 9, 10, 20, 21, 29, 30, "smallDelay",
		11, 19, 12, 18, 13, 17, 14, 15, "smallDelay",
		3, 4, 7, 8, 22, 23, 27, 28, "smallDelay",
		5, 6, 24, 25, 26, 41, 42, 43, 50, "smallDelay",
		44, 45, 46, 47, 48, 49
	},
	-- Challenging stage
	{
		1, 2, 3, 4, 5
	},
}

local delayTimes = 
{
	smallDelay = 2.5,
	mediumDelay = 4.0,
	largeDelay = 5.0,
}

function GameplayStartup()
	numSpawned = 0
	level = 1
	state = states.menu
end

function GameplayUpdate()
	if state == states.game then
		-- Update spawning
		local curLevel = levels[level]

		-- Wait some delay period
		if delayTimer > 0.0 then
			delayTimer = delayTimer - GetFrameDelta()
		else
			-- Spawn an enemy
			if spawnTimer >= spawnRate and numSpawned < #curLevel then
				numSpawned = numSpawned + 1
				local spawnId = curLevel[numSpawned]

				-- If the next enemy is just a delay
				if string.find(spawnId, "Delay") then
					delayTimer = delayTimes[spawnId]
				else
					local fastestFireRate = 3
					local fireRateMin = fastestFireRate - (GameplayGetHardness() * fastestFireRate)
					local fireRateMax = fireRateMin + (10 - level)
					EnemySpawn(spawnId, fireRateMin, fireRateMax)
					spawnTimer = 0.0
				end
			else
				-- Tick down the spawn timer
				spawnTimer = spawnTimer + GetFrameDelta()
			end
		end
	elseif state == states.death then
    -- Wait some delay period while the player contemplates their fuckup
    if delayTimer > 0.0 then
      delayTimer = delayTimer - GetFrameDelta()
    else
      if PlayerGetLives() > 0 then
        GameplayStartGameState()
      else
        GameplayGameOverState()
      end
    end
  end
end

function GameplayGetHardness()
	return math.min(level / 10)
end

function GameplayIsGameState()
	return state == states.game
end

function GameplayIsMenuState()
	return state == states.menu
end

function GameplayStartGameState()
	state = states.game
  PlayerBeginLife()
end

function GameplayDeathState()
    delayTimer = delayTimes.largeDelay
    state = states.death
end

function GameplayGameOverState()
  state = states.gameover
  GUIGameOver()
end

function GameplayNextGameState()
	if state < #states then
		state = state + 1
	end
end

function GameplayBackToMenu()
	state = states.menu
end

function GameplayGetState()
  return state
end
