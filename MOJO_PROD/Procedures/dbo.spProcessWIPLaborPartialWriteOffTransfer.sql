USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPLaborPartialWriteOffTransfer]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPLaborPartialWriteOffTransfer]
	(
	@TimeKey uniqueidentifier
	,@WriteOffHours decimal(24,4)
	,@WriteOffReasonKey int 
	,@PostingDate smalldatetime = Null
	)
AS --Encrypt

 /*
  || When         Who Rel         What
  || 04/23/13     GHL 10.5.6.7	 (167212) Created for partial write off of labor entries 
  || 11/20/14     GHL 10.5.8.6   Added currency + title info (title for Abelson Taylor)
  || 03/18/15     GHL 10.5.9.1   Added update of DepartmentKey (for Abelson Taylor)
  || 03/18/15     GHL 10.5.9.1   Cloned spProcessWIPLaborPartialWriteOff and made changes
  ||                             if the time entry is in WIP, we must perform a transfer
  */

/*
Errors:
-1		Not in WIP
-2      Already transferred
-3      on a billing worksheet
-4      Transfer did not go through
-5      Error subtracting WO hours on newly transferred time  
-6      Error creating WO time entry
*/

	SET NOCOUNT ON 

declare @RetVal int
declare @UserKey int
declare @ProjectKey int
declare @TaskKey int
declare @TitleKey int -- stays null
declare @IsAdjustment int
declare @TransferToKey uniqueidentifier
declare @TransferComment varchar(500)
declare @WorkDate smalldatetime
declare @AllowTransferDate int
declare @WIPPostingInKey int
declare @TransferDate smalldatetime

/*
Example: Time entry has 8 hours, we write off 3 hours

PostingDate = 3/17/15
if @AllowTransferDate = 1
	XferDate = PostingDate = 3/17/15
else
	XferDate = Workdate = 3/16/15 

      TimeKey  WorkDate    FTK     TTK    Hours     XferDate In   XferDate Out   WO  ILK    DateBilled
Orig    A       3/16/15    null    C       8         null          XferDate       0   0     XferDate
Revers  B       3/16/15    A       B      -8         XferDate      XferDate       0   0     XferDate     
New     C       3/16/15    A       null    8-->5     XferDate      null           0   null  null

note: after the transfer change to 5 hours

and add a writeoff, this one is not a transfer

WO      D       3/16/15    null    null    3         null          null           1   null   PostingDate 
*/


select @IsAdjustment = 1 -- This is an adjustment not a transfer 

select @ProjectKey = ProjectKey
      ,@TaskKey = TaskKey
	  ,@TransferToKey = TransferToKey
	  ,@UserKey = UserKey
	  ,@WorkDate = WorkDate
	  ,@WIPPostingInKey = WIPPostingInKey
from  tTime (nolock)
where TimeKey = @TimeKey

-- if not in WIP do not perform a transfer, we should do a regular partial WO
if @WIPPostingInKey = 0
	return -1

-- cannot transfer twice
if @TransferToKey is not null
	return -2

-- do not do a transfer if the record is on BWS, TimeKey on it would become obsolete
-- unless we do a swap of TimeKeys
if exists (select 1 from tBillingDetail (nolock) where Entity = 'tTime' and EntityGuid = @TimeKey)
	return -3

select @TransferComment = 'Adjustment due to time entry partial writeoff after WIP posting'

select @AllowTransferDate = pref.AllowTransferDate
from   tPreference pref (nolock)
	inner join tUser u (nolock) on isnull(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey 
where u.UserKey = @UserKey

if isnull(@AllowTransferDate, 1) = 1
	select @TransferDate = @PostingDate 
else
	select @TransferDate = @WorkDate 

-- First, perform a transfer, this will create a reversal and a new time entry
exec @RetVal = spProcessTranTransferTI @TimeKey,@ProjectKey,@TaskKey,@TransferDate,@TransferComment,@TransferComment,@TitleKey,@IsAdjustment,@TransferToKey output 

if @RetVal <0 
	return -4

begin tran

-- update new time entry with difference of hours 
update tTime 
set ActualHours = ActualHours - @WriteOffHours
where TimeKey = @TransferToKey
  	
if @@ERROR <> 0
begin
	rollback tran
	return -5
end
	
-- Now insert the WO 

	declare @NewTimeKey uniqueidentifier

	select @NewTimeKey = NEWID()
	 
  	-- duplicate original Time Entry, substitute write off hours 
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

		  ,DetailTaskKey
		  ,CurrencyID
		  ,ExchangeRate
		  ,HCostRate
		  ,TitleKey
		  ,DepartmentKey

		  -- and this is the WriteOff part
		  ,WriteOff 
	      ,BilledHours 
	      ,BilledRate 
	      ,WriteOffReasonKey
	      ,DateBilled 
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
      
		  ,DetailTaskKey
		  ,CurrencyID
		  ,ExchangeRate
		  ,HCostRate
		  ,TitleKey
  		 ,DepartmentKey

		   -- and this is the WriteOff part
		  ,1                    -- WriteOff 
	      ,0                    -- BilledHours
	      ,0                    -- BilledRate 
	      ,@WriteOffReasonKey   -- WriteOffReasonKey 
	      ,@PostingDate        -- DateBilled 
		  
	  from tTime (nolock)
     where TimeKey = @TimeKey 
     
	 if @@ERROR <> 0
	     begin
			rollback tran
		    return -6
	     end   
	       
	commit tran

	-- do this outside of the SQL transaction, this is just a rollup
	select @ProjectKey = ProjectKey from tTime (nolock) where TimeKey = @TimeKey
	if isnull(@ProjectKey, 0) > 0 
		EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 1, 1

	RETURN 1
GO
