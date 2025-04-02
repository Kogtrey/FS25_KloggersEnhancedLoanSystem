-- Name: ELS_settingsMenuExtension
-- Author: Chissel

ELS_settingsMenuExtension = {}

local modDirectory = g_currentModDirectory

source(modDirectory .. "src/Logger.lua")
local logger = Logger.create("FS25_KESL")
logger:setLevel(Logger.DEBUG)


function ELS_settingsMenuExtension:onFrameOpen()
    if self.els_initSettingsMenuDone then
        return
    end

    local target = ELS_settingsMenuExtension

    -- Section Header
    local title = self.gameSettingsLayout.elements[7]:clone()
    title:applyProfile("fs25_settingsSectionHeader", true)
    title:setText(g_i18n:getText("els_settingsMenu_sectionTitle"))
    title.focusChangeData = {}
    title.focusId = FocusManager.serveAutoFocusId()
    self.gameSettingsLayout:addElement(title)

    -- Dynamic Loan Interest
    self.els_dynamicLoanInterest = self.checkTraffic:clone()
    self.els_dynamicLoanInterest.target = target
    self.els_dynamicLoanInterest.id = "els_dynamicLoanInterest"
    self.els_dynamicLoanInterest:setCallback("onClickCallback", "onDynamicLoanInterestChanged")


    ELS_settingsMenuExtension:addOptionToLayout(
        self.gameSettingsLayout,
        self.els_dynamicLoanInterest,
        "dynamicLoanInterest",
        "els_settingsMenu_dynamicLoanInterestTitle",
        "els_settingsMenu_dynamicLoanInterestDescription",
        self.gameSettingsLayout.elements[5],
        "fs25_settingsBinaryOption"
    )

    -- Dynamic Loan Interest Value
    self.els_dynamicLoanInterestValue = self.economicDifficulty:clone()
    self.els_dynamicLoanInterestValue.target = target
    self.els_dynamicLoanInterestValue.id = "els_dynamicLoanInterestValue"
    self.els_dynamicLoanInterestValue:setCallback("onClickCallback", "onDynamicLoanInterestValueChanged")
    ELS_settingsMenuExtension.els_steps = g_els_loanManager.loanManagerProperties:getLoanInterestSteps()
    self.els_dynamicLoanInterestValue:setTexts(ELS_settingsMenuExtension.els_steps)
    

    ELS_settingsMenuExtension:addOptionToLayout(
        self.gameSettingsLayout,
        self.els_dynamicLoanInterestValue,
        "dynamicLoanInterestValue",
        "els_settingsMenu_dynamicLoanInterestValueTitle",
        "els_settingsMenu_dynamicLoanInterestValueDescription",
        self.gameSettingsLayout.elements[5],
        "fs25_settingsMultiTextOption"
    )

    -- Loan Duration Value
    self.els_loanDurationValue = self.economicDifficulty:clone()
    self.els_loanDurationValue.target = target
    self.els_loanDurationValue.id = "els_loanDurationValue"
    self.els_loanDurationValue:setCallback("onClickCallback", "onLoanDurationValueChanged")
    ELS_settingsMenuExtension.els_durationSteps = g_els_loanManager.loanManagerProperties:getLoanDurationSteps()
    self.els_loanDurationValue:setTexts(ELS_settingsMenuExtension.els_durationSteps)

    ELS_settingsMenuExtension:addOptionToLayout(
        self.gameSettingsLayout,
        self.els_loanDurationValue,
        "loanDurationValue",
        "els_settingsMenu_loanDurationValueTitle",
        "els_settingsMenu_loanDurationValueDescription",
        self.gameSettingsLayout.elements[5],
        "fs25_settingsMultiTextOption"
    )

    self.gameSettingsLayout:invalidateLayout()
    self.els_initSettingsMenuDone = true
    ELS_settingsMenuExtension:updateELSSettings(g_gui.currentGui.target.currentPage)

end

-- From ContractsPlus (Modified)
function ELS_settingsMenuExtension:addOptionToLayout(gameSettingsLayout, cloneElement, id, textId, descriptionId, settingsClone, profile)
    cloneElement.id = id

    local toolTip = cloneElement.elements[1]

    toolTip.text = g_i18n:getText(descriptionId)
    toolTip.sourceText = g_i18n:getText(descriptionId)

    local optionTitle = settingsClone.elements[2]:clone()
    optionTitle.id = id .. "Title"
    optionTitle:applyProfile("fs25_settingsMultiTextOptionTitle", true)
    optionTitle:setText(g_i18n:getText(textId))

    local optionContainer = settingsClone:clone()
    optionContainer.id = id .. "Container"
    optionContainer:applyProfile("fs25_multiTextOptionContainer", true)
    
    for key, v in pairs(optionContainer.elements) do
        optionContainer.elements[key] = nil
    end

    optionContainer:addElement(optionTitle)
    optionContainer:addElement(cloneElement)
    gameSettingsLayout:addElement(optionContainer)
end


function ELS_settingsMenuExtension:updateGameSettings()
    if not self.els_initSettingsMenuDone then
        return
    end

    ELS_settingsMenuExtension:updateELSSettings(self)
end

function ELS_settingsMenuExtension:updateELSSettings(currentPage)
    if currentPage.els_dynamicLoanInterest == nil or currentPage.els_dynamicLoanInterestValue == nil then
        return
    end

    if g_els_loanManager.loanManagerProperties.dynamicLoanInterest then
        currentPage.els_dynamicLoanInterest:setState(1)
        currentPage.els_dynamicLoanInterestValue:setDisabled(true)
    else
        currentPage.els_dynamicLoanInterest:setState(2)
        currentPage.els_dynamicLoanInterestValue:setDisabled(false)
    end

    for index, value in pairs(ELS_settingsMenuExtension.els_steps) do
        if tonumber(value) == g_els_loanManager.loanManagerProperties.loanInterest then
            currentPage.els_dynamicLoanInterestValue:setState(index)
        end
    end

    for index, value in pairs(ELS_settingsMenuExtension.els_durationSteps) do
        if tonumber(value) == g_els_loanManager.loanManagerProperties.maxLoanDuration then
            currentPage.els_loanDurationValue:setState(index)
        end
    end
end

function ELS_settingsMenuExtension:onDynamicLoanInterestChanged(state)
    g_els_loanManager:toggleDynamicLoanInterest()
    ELS_settingsMenuExtension:updateELSSettings(g_gui.currentGui.target.currentPage)
end

function ELS_settingsMenuExtension:onDynamicLoanInterestValueChanged(state)
    local loanInterestValue = tonumber(ELS_settingsMenuExtension.els_steps[state])
    g_els_loanManager:setLoanInterestValue(loanInterestValue)
    ELS_settingsMenuExtension:updateELSSettings(g_gui.currentGui.target.currentPage)
end

function ELS_settingsMenuExtension:onLoanDurationValueChanged(state)
    local loanDurationValue = tonumber(ELS_settingsMenuExtension.els_durationSteps[state])
    g_els_loanManager:setMaxLoanDurationValue(loanDurationValue)
    ELS_settingsMenuExtension:updateELSSettings(g_gui.currentGui.target.currentPage)
end

function init()
    InGameMenuSettingsFrame.updateGameSettings = Utils.appendedFunction(InGameMenuSettingsFrame.updateGameSettings, ELS_settingsMenuExtension.updateGameSettings)
    InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, ELS_settingsMenuExtension.onFrameOpen)
end

init()