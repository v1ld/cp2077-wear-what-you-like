-- Copyright (c) 2021 v1ld.git@gmail.com
-- This code is licensed under MIT license (see LICENSE for details)

WearWhatYouWant = {
    description = "WearWhatYouWant allows you to add slots unequip mods from armor",
    version = "v1.0"
}

function WearWhatYouWant.start()
    WearWhatYouWant.UI = require("ui/ui")
    WearWhatYouWant.Core = require("core/core")

    registerForEvent("onInit", function()
        print('WearWhatYouWant ' .. WearWhatYouWant.version .. ' initialized!')
    end)

    WearWhatYouWant.UI.run(WearWhatYouWant.version, WearWhatYouWant.Core)
end

WearWhatYouWant.start()
return WearWhatYouWant