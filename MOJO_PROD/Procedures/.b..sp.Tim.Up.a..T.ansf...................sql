USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeUpdateTransfer]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeUpdateTransfer]
	(
		@TimeKey uniqueidentifier,
		@ServiceKey int,
		@RateLevel smallint,
		@ActualRate money,
		@TransferDate smalldatetime =  NULL,
		@Comments varchar(2000) = NULL,
		@RecalcLaborRate int = 0
	)

AS --Encrypt

SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 11/19/14 GHL 10.586  Creation for the transfer/adjustment/editing of time entries posted to WIP 
  || 11/21/14 GHL 10.586  Take in account tPreference.AllowTransferDate for the transfer date
  ||                      + do not process if on a BWS
  || 01/23/15 GHL 10.588  For Abelson Taylor, added @RecalcLaborRate to modify the transfer comment
  ||                      appropriately when we recalculate labor rates 
 */

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
declare @OldActualRate money
declare @OldComments varchar(2000)

if @TransferDate is null
	SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
else
	-- cleanup time info
	SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), @TransferDate, 101)), 101)

select @IsAdjustment = 1 -- This is an adjustment not a transfer 

select @ProjectKey = ProjectKey
      ,@TaskKey = TaskKey
	  ,@TransferToKey = TransferToKey
	  ,@OldActualRate = ActualRate
	  ,@UserKey = UserKey
	  ,@WorkDate = WorkDate
	  ,@OldComments = Comments
from  tTime (nolock)
where TimeKey = @TimeKey

-- If the rate has not changed, do not perform a transfer
if isnull(@OldActualRate, 0) = isnull(@ActualRate, 0)
begin
	Update tTime
	Set    ServiceKey = @ServiceKey    
		  ,RateLevel = @RateLevel	
		  ,Comments = isnull(@Comments, Comments)
	Where  TimeKey = @TimeKey

	return 1
end

-- cannot transfer twice
if @TransferToKey is not null
	return -1

-- do not do a transfer if the record is on BWS, TimeKey on it would become obsolete
-- unless we do a swap of TimeKeys
if exists (select 1 from tBillingDetail (nolock) where Entity = 'tTime' and EntityGuid = @TimeKey)
	return -2

if @RecalcLaborRate = 0
	select @TransferComment = 'Adjustment due to time entry editing after WIP posting'
else
	select @TransferComment = 'Adjustment due to labor rate recalculated after WIP posting'

select @AllowTransferDate = pref.AllowTransferDate
from   tPreference pref (nolock)
	inner join tUser u (nolock) on isnull(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey 
where u.UserKey = @UserKey

if isnull(@AllowTransferDate, 1) = 0
	select @TransferDate = @WorkDate 

-- First, perform a transfer, this will create a reversal and a new time entry
exec @RetVal = spProcessTranTransferTI @TimeKey,@ProjectKey,@TaskKey,@TransferDate,@TransferComment,@TransferComment,@TitleKey,@IsAdjustment,@TransferToKey output 

if @RetVal <0 
	return -3

if @Comments is null
	select @Comments = @OldComments

declare @UpdateMode int
if @RecalcLaborRate = 1
	select @UpdateMode = 1 -- loop mode, we DO NOT recalc tProjectRollup 
else
	select @UpdateMode = 2 -- edit single shot mode, we recalc tProjectRollup

-- Second, update the new time entry
exec @RetVal = sptTimeUpdate @TransferToKey, @ProjectKey, @TaskKey,@ServiceKey,@RateLevel,@ActualRate,@UpdateMode, @Comments  

return 1
GO
