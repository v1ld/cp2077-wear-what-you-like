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

local player, transactionSystem, scriptableSystemsContainer, statsSystem, equipSystem, itemSystem, playerEquipSystem
-- FIXME: Would ideally only initialize when a save is loaded.
function Core.initGameValues()
    player = Game.GetPlayer()
    transactionSystem = Game.GetTransactionSystem()
    statsSystem = Game.GetStatsSystem()
    scriptableSystemsContainer = Game.GetScriptableSystemsContainer()
    equipSystem = scriptableSystemsContainer:Get(CName.new("EquipmentSystem"))
    itemSystem = scriptableSystemsContainer:Get(CName.new("ItemModificationSystem"))
    playerEquipSystem = equipSystem:GetPlayerData(player)
    playerEquipSystem['GetItemInEquipSlot2'] = playerEquipSystem['GetItemInEquipSlot;gamedataEquipmentAreaInt32']
end

function Core.ArmorSetRarity(desiredRarity, armorSlots)
    Core.initGameValues()

    local results, total = "", 0
    for slot, selected in pairs(armorSlots) do
        if selected then
            total = total + 1
            local itemID = playerEquipSystem:GetActiveItem(slot)
            if itemID.tdbid.hash ~= 0 then
                itemdata = transactionSystem:GetItemData(player, itemID)
                statObj = itemdata:GetStatsObjectID()
                local itemQuality = statsSystem:GetStatValue(statObj, 'Quality')
                if itemQuality ~= rarityValue[desiredRarity] then
                    statsSystem:RemoveAllModifiers(statObj, 'Quality', true)
                    local qualityMod = Game['gameRPGManager::CreateStatModifier;gamedataStatTypegameStatModifierTypeFloat']('Quality', 'Additive', rarityValue[desiredRarity])
                    statsSystem:AddSavedModifier(statObj, qualityMod)
                end
                results = results .. slot .. ': ' .. rarityName[math.floor(itemQuality)] .. ' => ' .. desiredRarity .. "\n"
            end
        end
    end
    if (total == 0) then
        results = "Select an armor slot to modify!\n"
    end
    return results
end

function Core.ArmorRemoveMods(armorSlots)
    Core.initGameValues()

    local results = ""
    local removed = false
    for slot, selected in pairs(armorSlots) do
        if selected then
            local itemID = playerEquipSystem:GetActiveItem(slot)
            if itemID.tdbid.hash ~= nil then
                local itemParts = Game['ItemModificationSystem::GetAllSlots;GameObjectItemID'](player, itemID)
                for _, part in pairs(itemParts) do
                    if part.installedPart.tdbid.hash ~= 0 then
                        itemSystem:RemoveItemPart(player, itemID, part.slotID, true)
                        results = results .. 'Removed mod from ' .. slot .. "\n"
                        removed = true
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