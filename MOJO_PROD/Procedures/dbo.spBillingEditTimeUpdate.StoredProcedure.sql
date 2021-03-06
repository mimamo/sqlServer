USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingEditTimeUpdate]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingEditTimeUpdate]
	@BillingKey INT
	,@EntityGuid uniqueidentifier
	,@Quantity decimal(24,4)
	,@Rate money
	,@Total money
	,@Comments varchar(2000)
	,@ServiceKey int
	,@RateLevel int
	,@UserKey int
	,@EditComments varchar(2000)
	
AS --Encrypt

/*
|| When     Who Rel    What
|| 10/04/06 CRG 8.35   Added a call to sptBillingRecalcTotals after the BillingDetail is updated.
|| 11/26/07 GHL 8.5    Added BillingKey parameter to restrict the Billing Detail record.
|| 01/22/15 GHL 10.588 For Abelson Taylor, added the option to update actual service and rate on the time entry 
||                     do not perform a transfer due to WIP, because in a billing WS, the time entry is as good as billed
*/
	declare @UpdateActualsOnBWS int

	select @UpdateActualsOnBWS = isnull(UpdateActualsOnBWS, 0)
	from   tPreference pref (nolock)
		inner join tBilling b (nolock) on pref.CompanyKey = b.CompanyKey
	where b.BillingKey = @BillingKey   
  	   

	update tBillingDetail
	   set Quantity = @Quantity
	      ,Rate = @Rate
	      ,Total = @Total
	      ,Comments = @Comments
	      ,ServiceKey = @ServiceKey
	      ,RateLevel = @RateLevel
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey
	 where EntityGuid = @EntityGuid
	 and   BillingKey = @BillingKey
	 
	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end

	EXEC sptBillingRecalcTotals @BillingKey

	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end

	if @UpdateActualsOnBWS = 1
		update tTime
		set    ServiceKey = @ServiceKey
		      ,ActualRate = @Rate
		where TimeKey = @EntityGuid

	if @@ERROR <> 0 
	  begin
		return -1					   	
	  end
	
	return 1
GO
