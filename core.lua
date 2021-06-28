-- Copyright (c) 2021 v1ld.git@gmail.com
-- This code is licensed under MIT license (see LICENSE for details)

local Core = {}

function Core.OnInit()
    Core.InitModSlots()
end

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

local player, transactionSystem, scriptableSystemsContainer, statsSystem, equipSystem, itemSystem, playerEquipSystem
function Core.InitGameValues()
    player = Game.GetPlayer()
    transactionSystem = Game.GetTransactionSystem()
    statsSystem = Game.GetStatsSystem()
    scriptableSystemsContainer = Game.GetScriptableSystemsContainer()
    equipSystem = scriptableSystemsContainer:Get(CName.new("EquipmentSystem"))
    itemSystem = scriptableSystemsContainer:Get(CName.new("ItemModificationSystem"))
    playerEquipSystem = equipSystem:GetPlayerData(player)
    playerEquipSystem['GetItemInEquipSlot2'] = playerEquipSystem['GetItemInEquipSlot;gamedataEquipmentAreaInt32']
end

local weaponSlot = {
    Weapon1 = 0,
    Weapon2 = 1,
    Weapon3 = 2
}

local function GetItemIDForSlot(slot)
    -- Weapon slots have "Weapon" as their name and 0,1,2 as their sub-slot id
    if (weaponSlot[slot]) then
        return playerEquipSystem:GetItemInEquipSlot2("Weapon", weaponSlot[slot])
    else
        return playerEquipSystem:GetActiveItem(slot)
    end
end

local function GetDisplayNameForItem(itemID)
    local displayNameTweakDBID = TweakDBID.new(itemID.id, '.displayName')
    local displayNameLocKey = Game['TDB::GetLocKey;TweakDBID'](displayNameTweakDBID)
    return Game.GetLocalizedTextByKey(displayNameLocKey)
end

function Core.SetRarity(desiredRarity, equipmentSlots)
    Core.InitGameValues()

    local results, total = "", 0
    for slot, selected in pairs(equipmentSlots) do
        if selected then
            total = total + 1
            local itemID = GetItemIDForSlot(slot)
            if itemID.tdbid.hash ~= 0 then
                itemdata = transactionSystem:GetItemData(player, itemID)
                statObj = itemdata:GetStatsObjectID()
                local itemQuality = statsSystem:GetStatValue(statObj, 'Quality')
                if itemQuality ~= rarityValue[desiredRarity] then
                    statsSystem:RemoveAllModifiers(statObj, 'Quality', true)
                    local qualityMod = Game['gameRPGManager::CreateStatModifier;gamedataStatTypegameStatModifierTypeFloat']('Quality', 'Additive', rarityValue[desiredRarity])
                    statsSystem:AddSavedModifier(statObj, qualityMod)
                end
                results = string.format("%s%s: %s => %s (%s)\n", results, GetDisplayNameForItem(itemID), rarityName[math.floor(itemQuality)], desiredRarity, slot)
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

function Core.InitModSlots()
    for _, slotName in ipairs(modSlotNames) do
        modSlot[tostring(TweakDBID.new(slotName))] = string.sub(slotName, -1)
    end
end

function Core.RemoveMods(equipmentSlots)
    Core.InitGameValues()

    local results, removed = "", false
    for slot, selected in pairs(equipmentSlots) do
        if selected then
            local itemID = GetItemIDForSlot(slot)
            if itemID.tdbid.hash ~= nil then
                local itemParts = Game['ItemModificationSystem::GetAllSlots;GameObjectItemID'](player, itemID)
                for _, part in pairs(itemParts) do
                    -- must be a mod slot with a mod equipped
                    if modSlot[tostring(part.slotID)] ~= nil and part.installedPart.tdbid.hash ~= 0 then
                        itemSystem:RemoveItemPart(player, itemID, part.slotID, true)
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

return Core