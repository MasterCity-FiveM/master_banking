ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent("pNotify:SendNotification", _source, { text = "مقدار وارد شده صحیح نیست.", type = "error", timeout = 3000, layout = "bottomCenter"})
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
		TriggerClientEvent('currentbalance1', _source, xPlayer.getAccount('bank').money)
		TriggerClientEvent("pNotify:SendNotification", _source, { text = "با تشکر از اعتماد شما، پول شما در بانک سپرده گذاری شد.", type = "success", timeout = 3000, layout = "bottomCenter"})
	end
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent("pNotify:SendNotification", _source, { text = "مقدار وارد شده صحیح نیست.", type = "error", timeout = 3000, layout = "bottomCenter"})
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('currentbalance1', _source, xPlayer.getAccount('bank').money)
		TriggerClientEvent("pNotify:SendNotification", _source, { text = "برداشت وجه انجام شد.", type = "success", timeout = 6000, layout = "bottomCenter"})
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0
	
	amount = tonumber(amount)
	if not amount then
		TriggerClientEvent("pNotify:SendNotification", _source, { text = "مقدار وارد شده صحیح نیست.", type = "error", timeout = 3000, layout = "bottomCenter"})
	end
	
	balance = xPlayer.getAccount('bank').money
	if tonumber(_source) == tonumber(to) or not zPlayer then
		TriggerClientEvent("pNotify:SendNotification", _source, { text = "کد ملی فرد وارد شده صحیح نیست.", type = "error", timeout = 3000, layout = "bottomCenter"})
	else
		if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
			TriggerClientEvent("pNotify:SendNotification", _source, { text = "موجودی حساب کافی نیست.", type = "error", timeout = 3000, layout = "bottomCenter"})
		else
			xPlayer.removeAccountMoney('bank', amount)
			zPlayer.addAccountMoney('bank', tonumber(amount))
			TriggerClientEvent('currentbalance1', _source, xPlayer.getAccount('bank').money)
			TriggerClientEvent("pNotify:SendNotification", _source, { text = "انتقال وجه انجام شد.", type = "success", timeout = 3000, layout = "bottomCenter"})
			TriggerClientEvent("pNotify:SendNotification", to, { text = "مبلغ " .. tostring(amount) .. " از حساب بانکی " .. tostring(_source) .. "، به حساب شما واریز شد.", type = "success", timeout = 6000, layout = "bottomCenter"})	
		end
	end
end)
