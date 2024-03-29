local RunService = game:GetService("RunService")

local ScriptUtils = {}

function ScriptUtils:Lerp(Min, Max, Alpha)
    return Min + ((Max - Min) * Alpha)
end

--- Executes code at a specific point in Roblox's engine
-- @module onSteppedFrame
function ScriptUtils.onSteppedFrame(_function)
	assert(type(_function) == "function")

	local conn
	conn = RunService.Stepped:Connect(function()
		conn:Disconnect()
		_function()
	end)

	return conn
end

function ScriptUtils:ConvertToBoolean(Input, parTrue, parFalse)
    if Input == parTrue then
        return true
    elseif Input == parFalse then
        return false
    end
end

function ScriptUtils:InverseLerp(value, min, max)
	return (value / 100) * (max - min) + min
end

--[=[
	Utility functions for animations
	@class AnimationTrackUtils
]=]
--[=[
	Loads an animation from the animation id
	@param animatorOrHumanoid Humanoid | Animator
	@param animationId string
	@return Animation
]=]
function ScriptUtils.loadAnimationFromId(animatorOrHumanoid, animationId)
	local animation = Instance.new("Animation")
	animation.AnimationId = animationId
	return animatorOrHumanoid:LoadAnimation(animation)
end

--[=[
	Sets the weight target if not set
	@param track AnimationTrack
	@param weight number
	@param fadeTime number
	@return Animation
]=]
function ScriptUtils.setWeightTargetIfNotSet(track, weight, fadeTime)
	assert(typeof(track) == "Instance", "Bad track")
	assert(type(weight) == "number", "Bad weight")
	assert(type(fadeTime) == "number", "Bad fadeTime")

	if track.WeightTarget ~= weight then
		track:AdjustWeight(weight, fadeTime)
	end
end

function ScriptUtils:DoubleInverseLinearInterpolation(value, min, max, mintwo, maxtwo)
	return (value - min) / (max - min) * (maxtwo - mintwo) + mintwo
end

function ScriptUtils:dubinvlerp(value, min, max, mintwo, maxtwo)
	return (value - min) / (max - min) * (maxtwo - mintwo) + mintwo
end

function ScriptUtils:HMSFormat(Int)
	return string.format("%02i", Int)
end

function ScriptUtils:ConvertToHMS(Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return self:HMSFormat(Hours)..":"..self:HMSFormat(Minutes)..":"..self:HMSFormat(Seconds)
end

function ScriptUtils:WeightedRandom(Dictionary, ReturnObject)
	local TotalWeight = 0
	for _, ChanceInfo in pairs(Dictionary) do
		TotalWeight = TotalWeight + ChanceInfo.Weight
	end

	local RandomNumber = math.random() * TotalWeight

	for _, ChanceInfo in pairs(Dictionary) do
		if  RandomNumber <= ChanceInfo.Weight then
			ChanceInfo.Chance = ChanceInfo.Weight / TotalWeight
			if ReturnObject == nil then
				return ChanceInfo.Object
			else
				return ChanceInfo
			end
		else
			RandomNumber = RandomNumber - ChanceInfo.Weight
		end
	end
end

function ScriptUtils:DeepCompare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not self:DeepCompare(v1, v2) then return false end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not self:DeepCompare(v1, v2) then return false end
    end
    return true
end

--[=[
	Utility functions involving functions
	@class FunctionUtils
]=]

--[=[
	Binds the "self" variable to the function as the first argument

	@param self table
	@param func function
	@return function
]=]
function ScriptUtils.bind(self, func)
	assert(type(self) == "table", "'self' must be a table")
	assert(type(func) == "function", "'func' must be a function")

	return function(...)
		return func(self, ...)
	end
end

function ScriptUtils:DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = self:DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

function ScriptUtils:NumberIsEvenOdd(Number)
	if Number % 2 == 0 then
		return true
	else
		return false
	end
end

function ScriptUtils:StringToBool(str)
	return string.lower(str or "") == "true"
end


return ScriptUtils
