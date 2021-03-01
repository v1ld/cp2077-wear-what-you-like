-- Copyright (c) 2021 v1ld.git@gmail.com
-- This code is licensed under MIT license (see LICENSE for details)

local UI = {}

local Core = require('core')

function UI.run(version)
    local showUI = false
    local head, face, innerChest, outerChest, legs, feet = false, false, false, false, false, false
    local weapon1, weapon2, weapon3 = false, false, false

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
            ImGui.Separator()
            ImGui.TextColored(1, 1, 0, 1, "Select armor or weapons to modify:")
            if ImGui.BeginTable("Table1", 4) then
                ImGui.TableNextRow()
                ImGui.TableSetColumnIndex(0)
                weapon1 = ImGui.Checkbox("Weapon 1", weapon1)
                ImGui.TableNextColumn()
                ImGui.Spacing()
                ImGui.TableNextColumn()
                head = ImGui.Checkbox("Head", head)
                ImGui.TableNextColumn()
                face = ImGui.Checkbox("Face", face)
                ImGui.TableNextColumn()
                weapon2 = ImGui.Checkbox("Weapon 2", weapon2)
                ImGui.TableNextColumn()
                ImGui.Spacing()
                ImGui.TableNextColumn()
                innerChest = ImGui.Checkbox("Shirt", innerChest)
                ImGui.TableNextColumn()
                outerChest = ImGui.Checkbox("Jacket", outerChest)
                ImGui.TableNextColumn()
                weapon3 = ImGui.Checkbox("Weapon 3", weapon3)
                ImGui.TableNextColumn()
                ImGui.Spacing()
                ImGui.TableNextColumn()
                legs = ImGui.Checkbox("Legs", legs)
                ImGui.TableNextColumn()
                feet = ImGui.Checkbox("Feet", feet)
                ImGui.EndTable()
            end
            ImGui.Separator()

            local equipmentSlots = {
                Head = head,
                Face = face,
                InnerChest = innerChest,
                OuterChest = outerChest,
                Legs = legs,
                Feet = feet,
                Weapon1 = weapon1,
                Weapon2 = weapon2,
                Weapon3 = weapon3
            }
            local lastLog = ""

            ImGui.Spacing()
            ImGui.TextColored(1, 1, 0, 1, "Armor or weapon mods:")
            ImGui.Spacing()
            if (ImGui.Button("Remove mods", buttonWidth, buttonHeight)) then
                lastLog = Core.RemoveMods(equipmentSlots)
            end
            ImGui.Spacing()
            ImGui.Separator()

            ImGui.Spacing()
            ImGui.TextColored(1, 1, 0, 1, "Change rarity to:")
            ImGui.Spacing()
            if (ImGui.Button("Common", buttonWidth, buttonHeight)) then
                lastLog = Core.SetRarity("Common", equipmentSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Uncommon", buttonWidth, buttonHeight)) then
                lastLog = Core.SetRarity("Uncommon", equipmentSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Rare", buttonWidth, buttonHeight)) then
                lastLog = Core.SetRarity("Rare", equipmentSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Epic", buttonWidth, buttonHeight)) then
                lastLog = Core.SetRarity("Epic", equipmentSlots)
            end
            ImGui.SameLine()
            if (ImGui.Button("Legendary", buttonWidth, buttonHeight)) then
                lastLog = Core.SetRarity("Legendary", equipmentSlots)
            end
            ImGui.Spacing()
            ImGui.Separator()

            ImGui.TextColored(1, 1, 0, 1, "Action log:")
            ImGui.Spacing()
            ImGui.BeginChild("Action Log", 485, 115, true)
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