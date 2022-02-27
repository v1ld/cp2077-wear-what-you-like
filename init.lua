-- Copyright (c) 2021 v1ld.git@gmail.com
-- This code is licensed under MIT license (see LICENSE for details)

WearWhatYouWant = {
    description = 'WearWhatYouWant allows you to add slots unequip mods from armor',
    version = 'v2.0'
}

local UI = require('ui')
local Core = require('core')

registerForEvent("onInit", function()
    print('WearWhatYouWant ' .. WearWhatYouWant.version .. ' initialized!')
end)

UI.run(WearWhatYouWant.version)

return WearWhatYouWant