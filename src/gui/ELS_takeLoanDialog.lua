-- Name: ELS_takeLoanDialog
-- Author: Chissel

ELS_takeLoanDialog = {}
local ELS_takeLoanDialog_mt = Class(ELS_takeLoanDialog, MessageDialog)

ELS_takeLoanDialog.CONTROLS = {
    "yesButton",
    "backButton",
	"loanAmountInput",
    "loanDurationInput",
    "loanInterestField",
    "loanPeriodRateField",
    "loanTotalAmountField",
    "loanAmountInputText"
}

function ELS_takeLoanDialog.new(target, custom_mt, i18n)
	local self = MessageDialog.new(target, custom_mt or ELS_takeLoanDialog_mt)

	-- self:registerControls(ELS_takeLoanDialog.CONTROLS)

    self.i18n = i18n
	self.callbackArgs = nil
    self.maxLoanAmount = 0
    self.loanInterest = 0
    self.maxLoanDuration = 5

	return self
end

function ELS_takeLoanDialog:onOpen()
	ELS_takeLoanDialog:superClass().onOpen(self)

    self:resetUI()

    self.loanAmountInputText:setText(string.format("%s (Max. %s):", self.i18n:getText("els_ui_takeLoanAmountInputText"), g_i18n:formatMoney(self.maxLoanAmount,0,true,true)))

	FocusManager:setFocus(self.loanAmountInput)
end

function ELS_takeLoanDialog:resetUI()
    self.loanAmountInput:setText("")
    self.loanDurationInput:setText("")
    self.loanAmountInput.lastValidText = ""
    self.loanDurationInput.lastValidText = ""
    self.yesButton:setDisabled(true)

    self.loanInterestField:setText(string.format("%s: %s", self.i18n:getText("els_ui_takeLoanInterest"), string.format("%.1f", self.loanInterest)))
    self.loanPeriodRateField:setText(string.format("%s: %s", self.i18n:getText("els_ui_takeLoanPeriodRate"), "-"))
    self.loanTotalAmountField:setText(string.format("%s: %s", self.i18n:getText("els_ui_takeLoanTotalAmount"), "-"))
end

function ELS_takeLoanDialog:setAvailableProperties(maxLoanAmount, loanInterest, maxLoanDuration)
    self.maxLoanAmount = math.max(maxLoanAmount, 0)
    self.loanInterest = loanInterest
    self.maxLoanDuration = maxLoanDuration
end

function ELS_takeLoanDialog:setCallback(callbackFunc, target)
    self.callbackFunc = callbackFunc
    self.target = target
end

function ELS_takeLoanDialog:onClickOk()
    self:sendCallback(true)
end

function ELS_takeLoanDialog:onClickCancel()
    self:sendCallback(false)
end

function ELS_takeLoanDialog:sendCallback(success)
    self:close()

    if self.callbackFunc ~= nil then
        if self.target ~= nil then
            local amountInput = tonumber(self.loanAmountInput.lastValidText)
            local durationInput = tonumber(self.loanDurationInput.lastValidText)
            self.callbackFunc(self.target, success, amountInput, durationInput)
        end
    end
end

function ELS_takeLoanDialog:onTextChanged(element, text)
    if text ~= "" then
        if tonumber(text) ~= nil then
            local value = text
            if element.id == "loanAmountInput" then
                local currentValue = tonumber(value)
                if currentValue > self.maxLoanAmount then
                    value = self.maxLoanAmount
                    element:setText(tostring(value))
                end
            elseif element.id == "loanDurationInput" then
                local currentValue = tonumber(value)
                if currentValue > self.maxLoanDuration then
                    value = self.maxLoanDuration
                    element:setText(tostring(value))
                end
            end

            local formattedValue = string.format("%.0f", value)
            element:setText(formattedValue)

            element.lastValidText = formattedValue
        else
            element:setText(element.lastValidText)
        end
    else
        element.lastValidText = ""
    end

    self:updateInfoIfNeeded()
    self:disableAcceptButtonIfNeeded()
end

function ELS_takeLoanDialog:disableAcceptButtonIfNeeded()
    if self.loanAmountInput.lastValidText ~= nil and
        self.loanDurationInput.lastValidText ~= nil and
        self.loanAmountInput.lastValidText ~= "" and
        self.loanDurationInput.lastValidText ~= "" and
        tonumber(self.loanAmountInput.lastValidText) > 0 and
        tonumber(self.loanDurationInput.lastValidText) > 0
    then
        self.yesButton:setDisabled(false)
    else
        self.yesButton:setDisabled(true)
    end
end

function ELS_takeLoanDialog:updateInfoIfNeeded()
    if self.loanAmountInput.lastValidText ~= nil and
        self.loanDurationInput.lastValidText ~= nil and
        self.loanAmountInput.lastValidText ~= "" and
        self.loanDurationInput.lastValidText ~= "" and
        tonumber(self.loanAmountInput.lastValidText) > 0 and
        tonumber(self.loanDurationInput.lastValidText) > 0
    then
        local amount = tonumber(self.loanAmountInput.lastValidText)
        local duration = tonumber(self.loanDurationInput.lastValidText)

        local loan = ELS_loan.new(false, false)
        loan:init(0, amount, self.loanInterest, duration)
        local periodRate = loan:calculateAnnuity()
        local totalAmount = loan:calculateTotalAmount()

        self.loanPeriodRateField:setText(string.format("%s: %s", self.i18n:getText("els_ui_takeLoanPeriodRate"), g_i18n:formatMoney(periodRate,0,true,true)))
        self.loanTotalAmountField:setText(string.format("%s: %s", self.i18n:getText("els_ui_takeLoanTotalAmount"), g_i18n:formatMoney(totalAmount,0,true,true)))
    else
        self.loanPeriodRateField:setText(string.format("%s: %s", self.i18n:getText("els_ui_takeLoanPeriodRate"), "-"))
        self.loanTotalAmountField:setText(string.format("%s: %s", self.i18n:getText("els_ui_takeLoanTotalAmount"), "-"))
    end
end