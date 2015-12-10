USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadDelete]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadDelete]
	@LeadKey int,
	@UserKey int = NULL

AS --Encrypt

/*
|| When     Who Rel      What
|| 11/26/08 GHL 10.5     Added tLeadUser deletion
|| 3/15/10  CRG 10.5.1.9 Added code to set the LeadKey to NULL in tCampaign and tProject
|| 3/23/10  GHL 10.5.2.1 Added deletion of estimates
|| 11/1/13  RLB 10.5.7.3 (194967) Added code to set WWP correctly on a lead delete
|| 04/27/15 KMC 10.5.9.1 (248283) Added @UserKey param and to pass through to sptSpecSheetDelete for insert into tActionLog
*/

if isnull(@LeadKey, 0) = 0
	return 1
	
Declare @CustomFieldKey int, @CurLevel int, @MaxLevel int, @ContactCompanyKey int, @CompanyKey int

SELECT @ContactCompanyKey = ContactCompanyKey, @CompanyKey = CompanyKey  FROM tLead (nolock) WHERE LeadKey = @LeadKey

declare @key int
select @key = -1

while 1=1
begin
	select @key = min(SpecSheetKey) from tSpecSheet (nolock) Where Entity = 'Leads' and EntityKey = @LeadKey and SpecSheetKey > @key
		if @key is null
			break
			
	exec sptSpecSheetDelete @key, @UserKey
		
end

Select @CustomFieldKey = CustomFieldKey from tLead (nolock) Where LeadKey = @LeadKey

exec spCF_tObjectFieldSetDelete @CustomFieldKey

DELETE tLevelHistory WHERE Entity = 'tLead' AND EntityKey = @LeadKey


Delete tLeadUser Where LeadKey = @LeadKey 

UPDATE tCampaign SET LeadKey = NULL WHERE LeadKey = @LeadKey

UPDATE tProject SET LeadKey = NULL WHERE LeadKey = @LeadKey

DELETE tEstimateUser FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateUser.EstimateKey AND
	LeadKey = @LeadKey

DELETE tEstimateTaskExpense FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTaskExpense.EstimateKey AND
	LeadKey = @LeadKey

DELETE tEstimateTaskAssignmentLabor FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTaskAssignmentLabor.EstimateKey AND
	LeadKey = @LeadKey

DELETE tEstimateTaskLabor FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTaskLabor.EstimateKey AND
	LeadKey = @LeadKey

DELETE tEstimateService FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateService.EstimateKey AND
	LeadKey = @LeadKey

DELETE tEstimateTask FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTask.EstimateKey AND
	LeadKey = @LeadKey

DELETE tEstimateNotify FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateNotify.EstimateKey AND
	LeadKey = @LeadKey

DELETE tEstimate WHERE LeadKey = @LeadKey

DELETE tEstimateTaskTemp where Entity = 'tLead' and EntityKey = @LeadKey
DELETE tEstimateTaskTempPredecessor where Entity = 'tLead' and EntityKey = @LeadKey
DELETE tEstimateTaskTempUser where Entity = 'tLead' and EntityKey = @LeadKey


DELETE FROM tLead WHERE LeadKey = @LeadKey 

-- Company
		Select @CurLevel = ISNULL(WWPCurrentLevel, 0) from tCompany (nolock) Where CompanyKey = @ContactCompanyKey
		
		Select @MaxLevel = ISNULL(MAX(WWPCurrentLevel), 0) from tLead (nolock)
		Where ContactCompanyKey = @ContactCompanyKey and 
		(LeadOutcomeKey is null OR LeadOutcomeKey in (Select LeadOutcomeKey from tLeadOutcome (nolock) Where CompanyKey = @CompanyKey and PositiveOutcome = 1))
		
		if @CurLevel <> ISNULL(@MaxLevel, 0)
		BEGIN
			Update tCompany Set WWPCurrentLevel = @MaxLevel Where CompanyKey = @ContactCompanyKey

			Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
			Values ('tCompany', @ContactCompanyKey, @MaxLevel, NULL, GETUTCDATE())

			
		END

-- anyone in the people tab
		declare @CurUserKey int
		select @CurUserKey = -1
		While 1=1
		BEGIN
			Select @CurUserKey = MIN(UserKey) from tUser (nolock) Where CompanyKey = @ContactCompanyKey and UserKey > @CurUserKey
				if @CurUserKey is null
					break
			
			Select @CurLevel = ISNULL(WWPCurrentLevel, 0) from tUser (nolock) Where UserKey = @CurUserKey
			
			Select @MaxLevel = ISNULL(MAX(WWPCurrentLevel), 0) from tLead l (nolock)
			inner join tLeadUser lu on l.LeadKey = lu.LeadKey
			Where lu.UserKey = @CurUserKey and 
			(LeadOutcomeKey is null OR LeadOutcomeKey in (Select LeadOutcomeKey from tLeadOutcome (nolock) Where CompanyKey = @CompanyKey and PositiveOutcome = 1))
		
			if @CurLevel <> ISNULL(@MaxLevel, 0)
			BEGIN
				Update tUser Set WWPCurrentLevel = @MaxLevel Where UserKey = @CurUserKey

				Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
				Values ('tUser', @CurUserKey, @MaxLevel, NULL, GETUTCDATE())
				
			END
		END

	RETURN 1
GO
