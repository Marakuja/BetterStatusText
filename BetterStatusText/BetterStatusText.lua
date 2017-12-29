-- hook to secure func TextStatusBar_UpdateTextStringWithValues from TextStatusBar.lua in Blizzard Standard UI
-- most of it is copy and paste from the standard lua.. Maybe shorten the not-used-parts for slightly better performance?
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function(statusFrame, textString, value, valueMin, valueMax)
    if ((tonumber(valueMax) ~= valueMax or valueMax > 0) and not (statusFrame.pauseUpdates)) then
        statusFrame:Show();
        
        local valueDisplay = value;
        local valueMaxDisplay = valueMax;
        valueDisplay = OwnAbbreviateLargeNumbers(value); -- My own Abbreviationfunction (smaller numbers)
        valueMaxDisplay = OwnAbbreviateLargeNumbers(valueMax); -- My own Abbreviationfunction (smaller numbers)
        
        local mytext = "";
        local textDisplay = GetCVar("statusTextDisplay");
        if (value and valueMax > 0 and ((textDisplay ~= "NUMERIC" and textDisplay ~= "NONE") or statusFrame.showPercentage) and not statusFrame.showNumeric) then
            if (textDisplay == "BOTH" and not statusFrame.showPercentage) then
                if (statusFrame.LeftText and statusFrame.RightText) then
                    if (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
                        mytext = math.ceil((value / valueMax) * 100) .. "% " -- only show the percentage when showing Mana
                    end
                    statusFrame.LeftText:Hide(); -- hide LeftText string
                    statusFrame.RightText:Hide(); -- hide RightText string
                else
                    valueDisplay = math.ceil((value / valueMax) * 100) .. "% " .. valueDisplay;
                end
                textString:SetText(mytext .. valueDisplay); -- set the textstring to our generated values
                textString:Show(); -- now show the middle textString
            end
        end
    end
end)

-- Everytime, when displaying numbers, abbreviate immediately when reaching the next 1k
function OwnAbbreviateLargeNumbers(value)
    local strLen = strlen(value);
    local retString = value;
    if (strLen >= 10) then
        retString = string.sub(value, 1, -10) .. "." .. string.sub(value, -9, -9) .. "G";
    elseif (strLen >= 7) then
        retString = string.sub(value, 1, -7) .. "." .. string.sub(value, -6, -6) .. "M";
    elseif (strLen >= 4) then
        retString = string.sub(value, 1, -4) .. "." .. string.sub(value, -3, -3) .. "k";
    end
    return retString;
end
