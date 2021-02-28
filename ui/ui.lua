-- Copyright (c) 2021 v1ld.git@gmail.com
-- This code is licensed under MIT license (see LICENSE for details)

local UI = {}

function UI.run(version, core)
    local showUI = false
    local head, face, innerChest, outerChest, legs, feet = false, false, false, false, false, false

    registerForEvent("onOverlayOpen", function()
        showUI = true
    end)

    registerForEvent("onOverlayClose", function()
        showUI = false
    end)

    local allLogs = ""
    local buttonWidth = 90
    local buttonHeight = 28

    registerForEvent("onDraw", function()
        if (not showUI) then return end

        ImGui.SetNextWindowPos(0, 250, ImGuiCond.FirstUseEver)
        ImGui.SetNextWindowSize(500, 425, ImGuiCond.Appearing)

        if ImGui.Begin("Wear What You Want") then
            ImGui.Spacing()
            ImGui.TextColored(1, 1, 0, 1, "Select armor slots to modify:")

            ImGui.Spacing()
            head = ImGui.Checkbox("Head", head)
            ImGui.SameLine()
            face = ImGui.Checkbox("Face", face)
            ImGui.SameLine()
            innerChest = ImGui.Checkbox("Shirt", innerChest)
            ImGui.SameLine()
            outerChest = ImGui.Checkbox("Jacket", outerChest)
            ImGui.SameLine()
            legs = ImGui.Checkbox("Legs", legs)
            ImGui.SameLine()
            feet = ImGui.Checkbox("Feet", feet)
            ImGui.Spacing()
            ImGui.Separator()

            local armorSlots = {
                Head = head,
                Face = face,
                InnerChest = innerChest,
                OuterChest = outerChest,
                Legs = legs,
                Feet = feet
            }
            local lastLog = ""

            ImGui.Spacing()
            ImGui.TextColored(1, 1, 0, 1, "Armor mods:")
            ImGui.Spacing()
            if (ImGui.Button("Remove mods", buttonWidth, buttonHeight)) then
                lastLog = core.ArmorRemoveMods(armorSlots)
            end
            ImGui.Spacing()
            ImGui.Separator()

            ImGui.Spacing()
            ImGui.TextColored(1, 1, 0, 1, "Change rarity to:")
            ImGui.Spacing()
            if (ImGui.Button("Common", buttonWidth, buttonHeight)) then
                lastLog = core.ArmorSetRarity("Common", armorSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Uncommon", buttonWidth, buttonHeight)) then
                lastLog = core.ArmorSetRarity("Uncommon", armorSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Rare", buttonWidth, buttonHeight)) then
                lastLog = core.ArmorSetRarity("Rare", armorSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Epic", buttonWidth, buttonHeight)) then
                lastLog = core.ArmorSetRarity("Epic", armorSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Legendary", buttonWidth, buttonHeight)) then
                lastLog = core.ArmorSetRarity("Legendary", armorSlots)
            end
            ImGui.Spacing()
            ImGui.Separator()

            ImGui.Spacing()
            ImGui.TextColored(1, 1, 0, 1, "Action log:")
            ImGui.Spacing()
            ImGui.BeginChild("Action Log", 485, 150, true)
            if (lastLog ~= "") then
                allLogs = lastLog .. allLogs
            end
            ImGui.Text(allLogs)
            ImGui.EndChild()
            ImGui.Separator()

            ImGui.Spacing()
            ImGui.Text(version)
        end
        ImGui.End()
    end)
end

return UI