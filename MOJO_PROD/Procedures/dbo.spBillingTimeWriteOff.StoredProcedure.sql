USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingTimeWriteOff]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingTimeWriteOff]

	 @TimeKey uniqueidentifier
	,@WriteOffHours decimal(24,4)
	,@WriteOffReasonKey int 
	,@UserKey int
	,@EditComments varchar(2000)
	,@PostingDate smalldatetime = Null
	,@BillingKey int
	
AS --Encrypt

 /*
  || When         Who Rel         What
  || 3/17/2009    RLB 10.1.2.1    (49082) Added posting date to partial write offs
  || 06/16/09     RLB 10.0.2.7    (54958) Fixed Partial write offs not updating Billing worksheet 
  || 06/29/09     GHL 10.0.2.7    (55992) Fixed problem described in bug
  ||                               One labor transaction is posted to WIP (5 hours at $100)
  ||                               then placed on a billing WS
  ||                               then partially written off (2 hours) 
  ||                               The WIP analysis report says:
  ||                               LABOR IN = $500, LABOR BILL = $300 cannot reconcile
  || 05/21/10     GHL 10.5.3.0	   (75885) Rolledback fix for 55992 because we have now tTime.WIPAmount to reconcile 
  || 01/22/15     GHL 10.5.8.8     Added multi currency fields 
  */

/* Removed because we have tTime.WIPAmount now
if (select WIPPostingInKey from tTime (nolock) Where TimeKey = @TimeKey) > 0
	return -5 
*/

declare @NewTimeKey uniqueidentifier

	select @NewTimeKey = NEWID()
	 
  	begin transaction
  	
  	-- duplicate original Time Entry, substiute write off hours 
	insert tTime
		  (TimeKey
		  ,TimeSheetKey
		  ,UserKey
		  ,ProjectKey
		  ,TaskKey
		  ,ServiceKey
		  ,RateLevel
		  ,WorkDate
		  ,StartTime
		  ,EndTime
		  ,ActualHours
		  ,PauseHours
		  ,ActualRate
		  ,Comments
		  ,CostRate
		  ,CurrencyID
		  ,ExchangeRate
		  ,HCostRate
		  )
	select @NewTimeKey
		  ,TimeSheetKey
		  ,UserKey
		  ,ProjectKey
		  ,TaskKey
		  ,ServiceKey
		  ,RateLevel
		  ,WorkDate
		  ,StartTime
		  ,EndTime
		  ,@WriteOffHours
		  ,PauseHours
		  ,ActualRate
		  ,Comments
		  ,CostRate
		  ,CurrencyID
		  ,ExchangeRate
		  ,HCostRate
      from tTime (nolock)
     where TimeKey = @TimeKey 
     
	 if @@ERROR <> 0
	     begin
		    rollback transaction
		    return -1 
	     end   
	       
	       
  	-- update original time entry
  	update tTime 
  	   set ActualHours = ActualHours - @WriteOffHours
  	 where TimeKey = @TimeKey
  	
	 if @@ERROR <> 0
	     begin
		    rollback transaction
		    return -2 
	     end 
	     
	       	
	--create new billing detail entry
	insert tBillingDetail
	      (BillingKey
	      ,Entity
	      ,EntityKey
	      ,EntityGuid
	      ,Action
	      ,Quantity
	      ,Rate
	      ,Total
	      ,Comments
	      ,WriteOffReasonKey
	      ,TransferProjectKey
	      ,TransferTaskKey
	      ,AsOfDate
	      ,TMPercentage
	      ,ServiceKey
	      ,RateLevel
	      ,EditComments
	      ,EditorKey
	      )
	select BillingKey
	      ,Entity
	      ,EntityKey
	      ,@NewTimeKey
	      ,0  -- write off
	      ,@WriteOffHours
	      ,Rate
	      ,round(Rate * @WriteOffHours,2)
	      ,Comments
	      ,@WriteOffReasonKey
	      ,TransferProjectKey
	      ,TransferTaskKey
	      ,@PostingDate
	      ,TMPercentage
	      ,ServiceKey
	      ,RateLevel 
	      ,@EditComments
	      ,@UserKey
	  from tBillingDetail (nolock)
	 where EntityGuid = @TimeKey and BillingKey = @BillingKey

	 if @@ERROR <> 0
	     begin
		    rollback transaction
		    return -3 
	     end 
	   
	 
	--update original billing entry
  	update tBillingDetail
  	   set Quantity = Quantity - @WriteOffHours
  	      ,Total = round((Quantity - @WriteOffHours) * Rate, 2)
  		  ,EditComments = @EditComments
  		  ,EditorKey = @UserKey	
  	where EntityGuid = @TimeKey and BillingKey = @BillingKey
  	 
	 if @@ERROR <> 0
	     begin
		    rollback transaction
		    return -4 
	     end   
	  
	commit transaction
	
	exec sptBillingRecalcTotals @BillingKey	  	

	return 1
GO
