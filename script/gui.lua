function GUIStartup()
	GUI:SetSelected("btnNewGame")
  GUI:SetActiveMenu("main")
  GUI:EnableMouse()
  SetScene("menu")
end

function GUIOnClickNewGame()
	GameplayStartGameState()
	GUI:SetActiveMenu("HUD")
	GUI:DisableMouse()
	SetScene("game")
end

function GUIGameOver()
  GUI:SetActiveMenu("gameover")
  SetScene("gameover")
end

function GUIOnClickSettings()
	GUI:SetActiveMenu("settings")
end

function GUIUpdate()
	if GameplayIsMenuState() then
		if IsKeyDown(keyCodes.Down) then
			GUI:SetSelected("btnSettings")
		elseif IsKeyDown(keyCodes.Up) then
			GUI:SetSelected("btnNewGame")
		end

		if IsKeyDown(keyCodes.Space) or IsKeyDown(keyCodes.Return) then
			GUI:Activate("btnNewGame")
		end
	else
		local scoreString = PlayerGetScore() .. " PTS"
		GUI:SetValue("score", scoreString)

		local numLives = PlayerGetLives() - 1
		local livesString = numLives .. "UP"
		if numLives > 0 then
			GUI:SetValue("lives", livesString)
			GUI:Show("lives")
		else
			GUI:Hide("lives")
		end

		if numLives >= 1 then
			GUI:Show("playerLife1")
		else 
			GUI:Hide("playerLife1")
		end

		if numLives >= 2 then
			GUI:Show("playerLife2")
		else 
			GUI:Hide("playerLife2")
		end
	end
end