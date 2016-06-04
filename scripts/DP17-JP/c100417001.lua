--沈黙の剣士－サイレント・ソードマン
--Silent Swordsman
--Script by mercury233
function c100417001.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c100417001.spcon)
	e2:SetOperation(c100417001.spop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100417001,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetOperation(c100417001.atkop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100417001,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c100417001.condition)
	e4:SetTarget(c100417001.target)
	e4:SetOperation(c100417001.operation)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100417001,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c100417001.spcon2)
	e5:SetTarget(c100417001.sptg2)
	e5:SetOperation(c100417001.spop2)
	c:RegisterEffect(e5)
end
function c100417001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsRace,1,nil,RACE_WARRIOR)
end
function c100417001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsRace,1,1,nil,RACE_WARRIOR)
	Duel.Release(g,REASON_COST)
end
function c100417001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c100417001.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100417001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100417001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c100417001.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE)
			or (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp))
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c100417001.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x1e7) or c:IsCode(1995985,74388798,37267041)) and not c:IsCode(100417001)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100417001.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100417001.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100417001.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100417001.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
