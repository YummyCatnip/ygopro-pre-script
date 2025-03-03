--CNo.79 BK 将星のカエサル

--Script by Chrono-Genex
function c100428035.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100428035.atkval)
	c:RegisterEffect(e1)
	--disable special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100428035,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100428035.discon)
	e2:SetTarget(c100428035.distg)
	e2:SetOperation(c100428035.disop)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100428035,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100428035.tgcon)
	e3:SetTarget(c100428035.tgtg)
	e3:SetOperation(c100428035.tgop)
	c:RegisterEffect(e3)
end
aux.xyz_number[100428035]=79
function c100428035.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c100428035.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
end
function c100428035.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c100428035.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)>0 then
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c100428035.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,71921856) then return false end
	local a,d=Duel.GetBattleMonster(tp)
	if a and d and a:IsFaceup() and a:IsSetCard(0x1084) then
		e:SetLabelObject(d)
		return true
	else return false end
end
function c100428035.tgfilter(c)
	return c:IsSetCard(0x1084) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c100428035.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc:IsCanOverlay()
		and Duel.IsExistingMatchingCard(c100428035.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100428035.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100428035.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToChain() and tc:IsControler(1-tp) then
			Duel.Overlay(c,tc)
		end
	end
end
