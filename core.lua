-- Copyright (c) 2021 v1ld.git@gmail.com
-- This code is licensed under MIT license (see LICENSE for details)

local Core = {}

local rarityValue = {
    Common = 0,
    Uncommon = 1,
    Rare = 2,
    Epic = 3,
    Legendary = 4
}
local rarityName = { }
for i,v in pairs(rarityValue) do
    rarityName[v] = i
end

local weaponSlot = {
    Weapon1 = 0,
    Weapon2 = 1,
    Weapon3 = 2
}

local function GetItemIDForSlot(slot)
    local playerEquipSystem = Game.GetScriptableSystemsContainer():Get("EquipmentSystem"):GetPlayerData(Game.GetPlayer())
    -- Weapon slots have "Weapon" as their name and 0,1,2 as their sub-slot id
    if (weaponSlot[slot]) then
        return playerEquipSystem:GetItemInEquipSlot("Weapon", weaponSlot[slot])
    else
        return playerEquipSystem:GetActiveItem(slot)
    end
end

local function GetDisplayNameForItem(itemID)
    local displayNameTweakDBID = TweakDBID.new(itemID.id, '.displayName')
    local displayNameLocKey = TDB.GetLocKey(displayNameTweakDBID)
    return Game.GetLocalizedTextByKey(displayNameLocKey)
end

function Core.SetRarity(desiredRarity, equipmentSlots)
    local results, total = "", 0
    for slot, selected in pairs(equipmentSlots) do
        if selected then
            total = total + 1
            local itemID = GetItemIDForSlot(slot)
            if itemID.tdbid.hash ~= 0 then
                local statsObjectID = Game.GetTransactionSystem():GetItemData(Game.GetPlayer(), itemID):GetStatsObjectID()
                local itemQuality = Game.GetStatsSystem():GetStatValue(statsObjectID, 'Quality')
                if itemQuality ~= rarityValue[desiredRarity] then
                    Game.GetStatsSystem():RemoveAllModifiers(statsObjectID, 'Quality', true)
                    local qualityMod = RPGManager.CreateStatModifier('Quality', 'Additive', rarityValue[desiredRarity])
                    Game.GetStatsSystem():AddSavedModifier(statsObjectID, qualityMod)
                end
                results = string.format("%s%s: %s -> %s (%s)\n", results, GetDisplayNameForItem(itemID), rarityName[math.floor(itemQuality)], desiredRarity, slot)
            end
        end
    end
    if (total == 0) then
        results = "Select an equipment slot to modify!\n"
    end
    return results
end

local modSlotNames = { 
    "AttachmentSlots.GenericWeaponMod1",
    "AttachmentSlots.GenericWeaponMod2",
    "AttachmentSlots.GenericWeaponMod3",
    "AttachmentSlots.GenericWeaponMod4",
    "AttachmentSlots.MeleeWeaponMod1",
    "AttachmentSlots.MeleeWeaponMod2",
    "AttachmentSlots.MeleeWeaponMod3",
    "AttachmentSlots.HeadFabricEnhancer1",
    "AttachmentSlots.HeadFabricEnhancer2",
    "AttachmentSlots.HeadFabricEnhancer3",
    "AttachmentSlots.HeadFabricEnhancer4",
    "AttachmentSlots.FaceFabricEnhancer1",
    "AttachmentSlots.FaceFabricEnhancer2",
    "AttachmentSlots.FaceFabricEnhancer3",
    "AttachmentSlots.FaceFabricEnhancer4",
    "AttachmentSlots.InnerChestFabricEnhancer1",
    "AttachmentSlots.InnerChestFabricEnhancer2",
    "AttachmentSlots.InnerChestFabricEnhancer3",
    "AttachmentSlots.InnerChestFabricEnhancer4",
    "AttachmentSlots.OuterChestFabricEnhancer1",
    "AttachmentSlots.OuterChestFabricEnhancer2",
    "AttachmentSlots.OuterChestFabricEnhancer3",
    "AttachmentSlots.OuterChestFabricEnhancer4",
    "AttachmentSlots.LegsFabricEnhancer1",
    "AttachmentSlots.LegsFabricEnhancer2",
    "AttachmentSlots.LegsFabricEnhancer3",
    "AttachmentSlots.LegsFabricEnhancer4",
    "AttachmentSlots.FootFabricEnhancer1",
    "AttachmentSlots.FootFabricEnhancer2",
    "AttachmentSlots.FootFabricEnhancer3",
    "AttachmentSlots.FootFabricEnhancer4"
}

local modSlot = { }

function Core.RemoveMods(equipmentSlots)
    if next(modSlot) == nil then
        for _, slotName in ipairs(modSlotNames) do
            modSlot[tostring(TweakDBID.new(slotName))] = string.sub(slotName, -1)
        end
    end

    local results, removed = "", false
    for slot, selected in pairs(equipmentSlots) do
        if selected then
            local itemID = GetItemIDForSlot(slot)
            if itemID.tdbid.hash ~= nil then
                local itemParts = Game.GetScriptableSystemsContainer():Get("ItemModificationSystem").GetAllSlots(Game.GetPlayer(), itemID)
                for _, part in pairs(itemParts) do
                    -- must be a mod slot with a mod equipped
                    if modSlot[tostring(part.slotID)] ~= nil and part.installedPart.tdbid.hash ~= 0 then
                        Game.GetScriptableSystemsContainer():Get("ItemModificationSystem"):RemoveItemPart(Game.GetPlayer(), itemID, part.slotID, true)
                        removed = true
                        results = string.format("%s%s: %s (%s)\n", results, GetDisplayNameForItem(itemID), GetDisplayNameForItem(part.installedPart), slot)
                    end
                end
            end
        end
    end

    if (not removed) then
        results = "No mods to remove!\n"
    end
    return results
end

function Core.LevelUp(equipmentSlots)
    local results = ""
    local playerPowerLevel = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), 'PowerLevel') or 0.0
    for slot, selected in pairs(equipmentSlots) do
        if selected then
            local itemID = GetItemIDForSlot(slot)
            if itemID.tdbid.hash ~= nil then
                local gameItemData = Game.GetTransactionSystem():GetItemData(Game.GetPlayer(), itemID)
                local itemPowerLevel   = gameItemData:GetStatValueByType('PowerLevel') or 0.0
                local itemUpgradeLevel = gameItemData:GetStatValueByType('WasItemUpgraded') or 0.0
                local itemLevel = itemPowerLevel + itemUpgradeLevel
                -- leveling up items at or one level below the player level can cause a drop in stats, so don't
                if itemLevel < playerPowerLevel - 1 then
                    -- true item level = base item level + item upgrade levels
                    -- remove the item upgrade levels first before we bump the base item level to player level
                    Game.GetStatsSystem():RemoveAllModifiers(gameItemData:GetStatsObjectID(), 'WasItemUpgraded', true)
                    Game.GetScriptableSystemsContainer():Get(CName.new('CraftingSystem')):SetItemLevel(gameItemData)
                    local newItemLevel = gameItemData:GetStatValueByType('PowerLevel') or 0.0
                    results = string.format("%s%s: Level %f -> %f (%s)\n", results, GetDisplayNameForItem(itemID), itemLevel, newItemLevel, slot)
                else
                    results = string.format("%s%s: Level %f, skipping (%s)\n", results, GetDisplayNameForItem(itemID), itemLevel, slot)
                end
            end
        end
    end
    return results
end

return Core