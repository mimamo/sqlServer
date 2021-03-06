USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10560]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10560]
AS

	update tCCEntry 
	set    SplitProjects = isnull(SplitProjects, 0)
	      ,SplitVouchers = isnull(SplitVouchers, 0)
		  ,Billable = case when isnull(ProjectKey, 0) > 0 then 1 else 0 end


-- if user has the right to post give them the right to unpost

	Declare @CurKey int

	Select @CurKey = -1

	While 1=1
	begin
	 Select @CurKey = Min(EntityKey) from tRightAssigned (nolock) Where EntityKey > @CurKey and RightKey = 940450 and EntityType = 'Security Group'
	 if @CurKey is null
	  Break

	INSERT tRightAssigned
	  (
	  EntityType,
	  EntityKey,
	  RightKey
	  )
	SELECT 'Security Group',@CurKey,940455


	end


Update tReviewRound Set LatestRound = 0

Update tReviewRound Set LatestRound = 1 Where ReviewRoundKey in (SELECT MAX(ReviewRoundKey) FROM tReviewRound GROUP BY ReviewDeliverableKey)

declare @key int
Select @key = -1

while 1=1
BEGIN
	Select @key = min(ApprovalStepKey) from tApprovalStep (nolock) Where ApprovalStepKey > @key
		if @key is null
			break

	exec sptApprovalStepUpdateStatusNames @key


END


-- change BillingGroupCode to BillingGroupKey

insert tBillingGroup (CompanyKey, GLCompanyKey, BillingGroupCode, Active)
select distinct CompanyKey, isnull(GLCompanyKey,0),  upper(LTRIM(rtrim(isnull(BillingGroupCode, '')))), 1
from   tProject (nolock)
where  LTRIM(rtrim(isnull(BillingGroupCode, ''))) <> ''

update tBillingGroup
set    GLCompanyKey = null
where  GLCompanyKey = 0

update tProject
set    tProject.BillingGroupKey = bg.BillingGroupKey
from   tBillingGroup bg (nolock)
where  tProject.CompanyKey = bg.CompanyKey
and    isnull(tProject.GLCompanyKey, 0) = isnull(bg.GLCompanyKey, 0)
and    upper(LTRIM(rtrim(isnull(tProject.BillingGroupCode, '')))) = bg.BillingGroupCode

update tBilling
set    tBilling.EntityKey = bg.BillingGroupKey
      ,tBilling.Entity = 'BillingGroup'
from   tBillingGroup bg (nolock)
where  upper(LTRIM(rtrim(isnull(tBilling.Entity, '')))) = bg.BillingGroupCode
and    tBilling.CompanyKey = bg.CompanyKey
and    isnull(tBilling.GLCompanyKey, 0) = isnull(bg.GLCompanyKey, 0)
AND    UPPER(ISNULL(tBilling.Entity, ''))  NOT IN ('', 'PROJECT', 'CLIENT', 'PARENTCLIENT', 'DIVISION', 'PRODUCT', 'CAMPAIGN', 'RETAINER', 'RETAINERMASTER')

update tBilling
set    tBilling.GroupEntityKey = bg.BillingGroupKey
      ,tBilling.GroupEntity = 'BillingGroup'
from   tBillingGroup bg (nolock)
where  upper(LTRIM(rtrim(isnull(tBilling.GroupEntity, '')))) = bg.BillingGroupCode
and    tBilling.CompanyKey = bg.CompanyKey
and    isnull(tBilling.GLCompanyKey, 0) = isnull(bg.GLCompanyKey, 0)
AND    UPPER(ISNULL(tBilling.GroupEntity, ''))  NOT IN ('', 'PROJECT', 'CLIENT', 'PARENTCLIENT', 'DIVISION', 'PRODUCT', 'CAMPAIGN', 'RETAINER', 'RETAINERMASTER')
GO
