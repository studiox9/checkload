function Library:CheckUpdate(rawUrl)
    if not rawUrl then return end
    task.spawn(function()
        local ok, result = pcall(function()
            return game:HttpGet(rawUrl)
        end)
        if ok and result then
            local remoteVer = result:match('Version%s*=%s*"([%d%.]+[^"]*)"')
            if remoteVer and remoteVer ~= Library.Version then
                Library:Notify("Update", "New version: " .. remoteVer, 4)
            end
        end
    end)
end


function Library:DetectSystemLanguage()
    local locale = ""
    pcall(function()
        local ls = game:GetService("LocalizationService")
        locale = (ls.RobloxLocaleId or ls.SystemLocaleId or ""):lower()
    end)
    if locale == "" then
        pcall(function()
            locale = (Player.LocaleId or ""):lower()
        end)
    end

    
    local map = {
        
        ["vi"] = "VI", ["vi-vn"] = "VI",
        
        ["en"] = "EN", ["en-us"] = "EN", ["en-gb"] = "EN", ["en-au"] = "EN",
        
        ["zh"] = "ZH", ["zh-cn"] = "ZH", ["zh-tw"] = "ZH", ["zh-hans"] = "ZH", ["zh-hant"] = "ZH",
        
        ["ja"] = "JA", ["ja-jp"] = "JA",
        
        ["ko"] = "KO", ["ko-kr"] = "KO",
        
        ["th"] = "TH", ["th-th"] = "TH",
        
        ["id"] = "ID", ["id-id"] = "ID",
        
        ["ms"] = "MS", ["ms-my"] = "MS",
        
        ["tl"] = "TL", ["fil"] = "TL", ["fil-ph"] = "TL",
        
        ["hi"] = "HI", ["hi-in"] = "HI",
        
        ["ar"] = "AR", ["ar-sa"] = "AR", ["ar-eg"] = "AR",
        
        ["ru"] = "RU", ["ru-ru"] = "RU",
        
        ["uk"] = "UK", ["uk-ua"] = "UK",
        
        ["fr"] = "FR", ["fr-fr"] = "FR", ["fr-ca"] = "FR",
        
        ["de"] = "DE", ["de-de"] = "DE",
        
        ["es"] = "ES", ["es-es"] = "ES", ["es-mx"] = "ES",
        
        ["pt"] = "PT", ["pt-br"] = "PT", ["pt-pt"] = "PT",
        
        ["it"] = "IT", ["it-it"] = "IT",
        
        ["tr"] = "TR", ["tr-tr"] = "TR",
        
        ["pl"] = "PL", ["pl-pl"] = "PL",
        
        ["nl"] = "NL", ["nl-nl"] = "NL",
        
        ["sv"] = "SV", ["sv-se"] = "SV",
        
        ["no"] = "NO", ["nb"] = "NO", ["nn"] = "NO", ["nb-no"] = "NO",
        
        ["da"] = "DA", ["da-dk"] = "DA",
        
        ["fi"] = "FI", ["fi-fi"] = "FI",
        
        ["cs"] = "CS", ["cs-cz"] = "CS",
        
        ["ro"] = "RO", ["ro-ro"] = "RO",
        
        ["hu"] = "HU", ["hu-hu"] = "HU",
        
        ["el"] = "EL", ["el-gr"] = "EL",
    }

    if map[locale] and Library.Lang[map[locale]] then
        return map[locale]
    end

    
    local short = locale:match("^(%a%a)")
    if short then
        local code = map[short]
        if code and Library.Lang[code] then
            return code
        end
        
        local upper = short:upper()
        if Library.Lang[upper] then
            return upper
        end
    end

    return "EN" 
end

function Library:SetLanguage(lang)
    if Library.Lang[lang] then
        Library.Language = lang
        Library:Notify("Language", lang, 1.5, "info")
        for _, w in pairs(Library.Windows) do
            if w.SearchBox then
                pcall(function() w.SearchBox.PlaceholderText = L("Search") end)
            end
        end
    end
end

