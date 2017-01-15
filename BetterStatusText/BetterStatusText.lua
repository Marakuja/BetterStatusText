-- hook to secure func TextStatusBar_UpdateTextStringWithValues from TextStatusBar.lua in Blizzard Standard UI
-- most of it is copy and paste from the standard lua.. Maybe shorten the not-used-parts for slightly better performance?

hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function(statusFrame, textString, value, valueMin, valueMax)

	if( statusFrame.LeftText and statusFrame.RightText ) then
		statusFrame.LeftText:SetText("");
		statusFrame.RightText:SetText("");
		statusFrame.LeftText:Hide();
		statusFrame.RightText:Hide();
	end

	if ( ( tonumber(valueMax) ~= valueMax or valueMax > 0 ) and not ( statusFrame.pauseUpdates ) ) then
		statusFrame:Show();
		
		if ( (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) or statusFrame.forceShow ) then
			textString:Show();
		elseif ( statusFrame.lockShow > 0 and (not statusFrame.forceHideText) ) then
			textString:Show();
		else
			textString:SetText("");
			textString:Hide();
			return;
		end

		local valueDisplay = value;
		local valueMaxDisplay = valueMax;
		if ( statusFrame.capNumericDisplay ) then
			valueDisplay = OwnAbbreviateLargeNumbers(value); -- My own Abbreviationfunction (smaller numbers)
			valueMaxDisplay = OwnAbbreviateLargeNumbers(valueMax); -- My own Abbreviationfunction (smaller numbers)
		else
			valueDisplay = BreakUpLargeNumbers(value);
			valueMaxDisplay = BreakUpLargeNumbers(valueMax);
		end

		local textDisplay = GetCVar("statusTextDisplay");
		if ( value and valueMax > 0 and ( textDisplay ~= "NUMERIC" or statusFrame.showPercentage ) and not statusFrame.showNumeric) then
			if ( value == 0 and statusFrame.zeroText ) then
				textString:SetText(statusFrame.zeroText);
				statusFrame.isZero = 1;
				textString:Show();
			elseif ( textDisplay == "BOTH" and not statusFrame.showPercentage) then
                -- here begins our addition, mytext for storing information
				local mytext = "";
				if( statusFrame.LeftText and statusFrame.RightText ) then
					if(not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
						mytext = math.ceil((value / valueMax) * 100) .. "% " -- only show the percentage when showing Mana
						statusFrame.LeftText:SetText(math.ceil((value / valueMax) * 100) .. "%");
						statusFrame.LeftText:Hide(); -- hide LeftText string
					end
					statusFrame.RightText:SetText(valueDisplay);
					statusFrame.RightText:Hide(); -- hide RightText string
					textString:Show(); -- now show the middle textString
				else
					valueDisplay = "(" .. math.ceil((value / valueMax) * 100) .. "%) " .. valueDisplay .. " / " .. valueMaxDisplay;
				end
				-- begin
				-- textString:Show();
				-- statusFrame.LeftText:Hide();
				-- statusFrame.RightText:Hide();
				-- end
				textString:SetText(mytext .. valueDisplay); -- set the textstring to our generated values
			else
				valueDisplay = math.ceil((value / valueMax) * 100) .. "%";
				if ( statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) ) ) then
					textString:SetText(statusFrame.prefix .. " " .. valueDisplay);
				else
					textString:SetText(valueDisplay);
				end
			end
		elseif ( value == 0 and statusFrame.zeroText ) then
			textString:SetText(statusFrame.zeroText);
			statusFrame.isZero = 1;
			textString:Show();
			return;
		else
			statusFrame.isZero = nil;
			if ( statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) ) ) then
				textString:SetText(statusFrame.prefix.." "..valueDisplay.." / "..valueMaxDisplay);
			else
				textString:SetText(valueDisplay.." / "..valueMaxDisplay);
			end
		end
	else
		textString:Hide();
		textString:SetText("");
		if ( not statusFrame.alwaysShow ) then
			statusFrame:Hide();
		else
			statusFrame:SetValue(0);
		end
	end
end)

-- Everytime, when displaying numbers, abbreviate immediately when reaching the next 1k
function OwnAbbreviateLargeNumbers(value)
	local strLen = strlen(value);
	local retString = value;
	if (true) then
		if ( strLen >= 10 ) then
			retString = string.sub(value, 1, -10).."."..string.sub(value, -9, -9).."G";
		elseif ( strLen >= 7 ) then
			retString = string.sub(value, 1, -7).."."..string.sub(value, -6, -6).."M";
		elseif ( strLen >= 4 ) then
			retString = string.sub(value, 1, -4).."."..string.sub(value, -3, -3).."k";
		end
	else
		if ( strLen >= 10 ) then
			retString = string.sub(value, 1, -10).."G";
		elseif ( strLen >= 7 ) then
			retString = string.sub(value, 1, -7).."M";
		elseif ( strLen >= 4 ) then
			retString = string.sub(value, 1, -4).."k";
		end
	end
	return retString;
end