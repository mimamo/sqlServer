USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadCopyEstimatesFromProject]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadCopyEstimatesFromProject]
	(
	@TemplateProjectKey int
	,@LeadKey int
	,@UserKey int
	)
	
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 4/07/10   GHL 10.5.2.1 Creation for new functionality (Copy estimates from a template project on opp screen)
||                        The project and tasks should be saved in tEstimateTaskTemp 
||                        and should be the same on the template project and the opportunity
||                        So first use the normal template copy function (no need to convert tasks)
||
||                        Then set the InternalApprover and PrimaryContactKey 
||                        Then do we need to readjust the labor rates and item markups based on client?   
|| 4/8/10    GWG 10.5.2.1 Added copy of Billing Items.
|| 11/11/10  GHL 10.5.3.8 (94144) Modified call to sptEstimateCopy (new param UserKey)
*/ 

declare @EstimateKey int
declare @NewEstimateKey int
declare @RetVal int
declare	@ProjectKey int 
declare	@CampaignKey int 
declare @CopyApproval int -- copy estimate approval 

select @TemplateProjectKey = isnull(@TemplateProjectKey, 0)
select @LeadKey = isnull(@LeadKey, 0)

if @TemplateProjectKey <=0
	return 1
if @LeadKey <=0
	return 1

declare @ClientKey int
declare @InternalApprover int
declare @PrimaryContactKey int
declare @LayoutKey int

declare @ClientInternalApprover int
declare @ClientPrimaryContactKey int
declare @ClientLayoutKey int
declare @EstimateTemplateKey int

select @ClientKey = l.ContactCompanyKey
      ,@InternalApprover = l.AccountManagerKey
      ,@PrimaryContactKey = l.ContactKey
      ,@LayoutKey = l.LayoutKey
      ,@ClientInternalApprover = cl.AccountManagerKey
      ,@ClientPrimaryContactKey = cl.PrimaryContact      
      ,@ClientLayoutKey = cl.LayoutKey
      ,@EstimateTemplateKey = cl.EstimateTemplateKey
 from   tLead l (nolock)
	left outer join tCompany cl (nolock) on l.ContactCompanyKey = cl.CompanyKey 
where  l.LeadKey = @LeadKey

if isnull(@InternalApprover, 0) = 0
	select @InternalApprover = @ClientInternalApprover
	
if isnull(@PrimaryContactKey, 0) = 0
	select @PrimaryContactKey = @ClientPrimaryContactKey
	
if isnull(@LayoutKey, 0) = 0
	select @LayoutKey = @ClientLayoutKey
	
	
select @EstimateKey = -1
while (1=1)
begin
	select @EstimateKey = min(EstimateKey)
	from   tEstimate (nolock)
	where  ProjectKey = @TemplateProjectKey
	and    EstimateKey > @EstimateKey
	
	if @EstimateKey is null
		break

	select @ProjectKey = null, @CampaignKey = null, @CopyApproval = 0	-- do not copy approval status  
	
	exec @RetVal = sptEstimateCopy @EstimateKey, @ProjectKey, @CampaignKey, @LeadKey, @CopyApproval, @UserKey, @NewEstimateKey output

	update tEstimate
	set    tEstimate.InternalApprover = @InternalApprover
		  ,tEstimate.PrimaryContactKey = @PrimaryContactKey
		  ,tEstimate.EstimateTemplateKey = @EstimateTemplateKey
		  ,tEstimate.LayoutKey = @LayoutKey
		  ,tEstimate.AddressKey = null  -- probably wrong address on the source estimate
	where  EstimateKey = @NewEstimateKey      

	exec sptEstimateApplyClientRateMarkup @NewEstimateKey, @ClientKey
	
end

Delete tWorkTypeCustom Where Entity = 'tLead' and EntityKey = @LeadKey
Insert tWorkTypeCustom (Entity, EntityKey, WorkTypeKey, Subject, Description)
Select 'tLead', @LeadKey, WorkTypeKey, Subject, Description
from tWorkTypeCustom Where Entity = 'tProject' and EntityKey = @TemplateProjectKey

      
	RETURN 1
GO
