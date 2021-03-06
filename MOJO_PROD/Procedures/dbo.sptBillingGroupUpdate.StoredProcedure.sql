USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGroupUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGroupUpdate]
	(
	@BillingGroupKey int
	,@CompanyKey int 
	,@GLCompanyKey int
	,@BillingGroupCode varchar(200)
	,@Description varchar(200)
	,@Active tinyint 
	)
	
AS --Encrypt
	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 09/25/12 GHL 10.560   Creation for HMI request
  */

  if exists(select 1 from tBillingGroup (NOLOCK) 
		Where CompanyKey = @CompanyKey 
		and BillingGroupCode = @BillingGroupCode
		and BillingGroupKey <> @BillingGroupKey)
	return -1

	if exists (select 1 
				from tProject (nolock)
				where CompanyKey = @CompanyKey 
				and   BillingGroupKey = @BillingGroupKey
				and   isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0) 
				)
				return -2

	if exists (select 1 
				from tBilling (nolock)
				where CompanyKey = @CompanyKey 
				and   Entity = 'BillingGroup' and EntityKey = @BillingGroupKey
				and   isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0) 
				)
				return -3

	if exists (select 1 
				from tBilling (nolock)
				where CompanyKey = @CompanyKey 
				and   GroupEntity = 'BillingGroup' and GroupEntityKey = @BillingGroupKey
				and   isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0) 
				)
				return -3

	if exists (select 1 
				from tInvoice (nolock)
				where CompanyKey = @CompanyKey 
				and   BillingGroupKey = @BillingGroupKey
				and   isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0) 
				)
				return -4


  if isnull(@BillingGroupKey, 0) > 0
  begin
		update tBillingGroup
		set    CompanyKey = @CompanyKey
		      ,GLCompanyKey = @GLCompanyKey
			  ,BillingGroupCode = @BillingGroupCode
			  ,Description = @Description
			  ,Active = @Active
		where BillingGroupKey = @BillingGroupKey

		return @BillingGroupKey
  end
  else
  begin
	insert tBillingGroup (
		CompanyKey
		,GLCompanyKey
		,BillingGroupCode
		,Description
		,Active
		)
	values (
		@CompanyKey
		,@GLCompanyKey
		,@BillingGroupCode
		,@Description
		,@Active
		)
		
	select @BillingGroupKey = @@Identity

	return @BillingGroupKey
  end
GO
