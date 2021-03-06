USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGroupDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGroupDelete]
	(
	@BillingGroupKey int
	)
AS --Encrypt
	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 09/25/12 GHL 10.560   Creation for HMI request
  */

	declare @CompanyKey int

	select @CompanyKey = CompanyKey from tBillingGroup (nolock) where BillingGroupKey = @BillingGroupKey

	if exists (select 1 
				from tProject (nolock)
				where CompanyKey = @CompanyKey 
				and BillingGroupKey = @BillingGroupKey
				)
				return -1

	if exists (select 1 
				from tBilling (nolock)
				where CompanyKey = @CompanyKey 
				and Entity = 'BillingGroup' and EntityKey = @BillingGroupKey
				)
				return -2

	if exists (select 1 
				from tBilling (nolock)
				where CompanyKey = @CompanyKey 
				and GroupEntity = 'BillingGroup' and GroupEntityKey = @BillingGroupKey
				)
				return -2

	if exists (select 1 
				from tInvoice (nolock)
				where CompanyKey = @CompanyKey 
				and BillingGroupKey = @BillingGroupKey
				)
				return -3


	delete tBillingGroup where BillingGroupKey = @BillingGroupKey

	RETURN 1
GO
