Wear What You Want
==================

Came across a lovely jacket that has no slots on it that you wish you could slap some mods into and wear?  Came across an ugly motorcycle helmet with a Bully and Fortuna mod equipped on it?  Wish you could have 2 slots on that jacket?  Wish you could unequip the mods from that SMG and put them on the Assault Rifle?  Wish you could keep those items leveled up with you as you go through the game?

This mod lets you do all these things: change the rarity of weapons and armor so they get more slots, unequip mods from gear so they can be reused elsewhere and level up gear to your level.

The number of mod slots depends on the type and rarity of an armor.  Shirts and jackets get 2 slots each at Rare and higher, while all the others get 1 slot each.

Installation
============

This mod requires the "Cyber Engine Tweaks" mod from https://www.nexusmods.com/cyberpunk2077/mods/107.  Install and get that working first, including assigning it a hot key to bring up the console.

Copy the bin folder contained in the .7z archive you downloaded to the root of your Cyberpunk 2077 install, which should already contain a bin folder.

If installed correctly, a WearWhatYouWant window will open up along with the CET console.

Usage
=====

Go to the Inventory window and check you're wearing the pieces you want to change.  Use the CET hot key to bring up the WWYW window.  Select the armor or weapons you wish to modify.  Click the appropriate action button.  Check the action log to see what underlying changes were made.

Note: Sometimes you'll come across gear that has less than the normal slots for their rarity.  If you remove mods from them - even if seems to have no mods equipped - a hidden internal mod named ME-THRILL will pop out.  Once this is removed the gear will behave as usual and have all the slots you expect.  Break down your ME-THRILLs for components if you like.

But starting from patch 1.5 armor can have intrinsic properties that don't show up as mod slots.  If you use the remove mods action on such armor, they will lose their intrinsic property but you will gain mod slots where the properties used to be.  This is useful if you don't like the instrinsic property but do want to use the gear.

Leveling Up
===========

TL;DR: Feel free to use Level Up liberally, it will keep your items close to your level as you progress through the game.

Item levels are somewhat messy and complicated under the hood.  This mod uses the game's own Crafting System to level up items so as to stay compatible with further patches.  But that internal game code will only level up items to 1 level below the player's actual level - or it will display such a level anyway.  

It is also possible to lose a very little bit of dps if you level up items that are 1-2 levels below the player's level - so this mod will skip level up for items close enough to the player's level where this could happen.  You can use Crafting upgrades to close this gap if you like.

Finally, the game tracks Crafting upgrades separately from base item level internally.  This mod resets the crafting upgrade level to 0 for each item it levels up so that future crafting upgrades by the player will be cheaper.

If this sounds complicated, just ignore all the words and use Level Up liberally.

Credits
=======

I looked closely at two mods for implementation details and code when putting this together:
- [pvpxan's LegendaryLite (with quest flag remover)](https://www.nexusmods.com/cyberpunk2077/mods/1414)
- [Captain12's Gameplay Patches](https://www.nexusmods.com/cyberpunk2077/mods/1421)

Much thanks to both of them, especially LegendaryLite which provided the original motivation to put this together.