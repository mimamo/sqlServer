USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserTitleUpdate]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserTitleUpdate]
	(
	 @UserKey int
	,@ActionOnUserKey int
 	,@TitleKey int
    ,@UpdateEntries smallint
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 10/16/14 WDF 10.585  Created for Abelson Taylor
|| 11/05/14 GHL 10.586  Tweaked and added time transfers 
|| 11/06/14 GHL 10.586  Added project rollup
|| 11/19/14 GHL 10.586  Updated to new spProcessTranTransferTI interface
|| 11/21/14 GHL 10.586  Do not Xfer if billed or on a BWS transactions
|| 01/06/15 GHL 10.588  Change Adjustment Type to 2 to distinguish from other adjustments 
|| 01/19/15 GHL 10.588  Do not Xfer if maked as billed or written off
|| 01/21/15 GHL 10.588  When changing titles, refresh on the user, the services from the title
*/
	SET NOCOUNT ON
	
	DECLARE @CompanyKey int, @OldTitleID varchar(50), @OldTitleKey int,  @TitleID varchar(50)
	DECLARE @ActionByName varchar(201), @ActionOnName varchar(201), @CurrentDate as datetime
	DECLARE @Msg varchar(4000), @MsgStartDate varchar(10), @MsgEndDate varchar(10)

	DECLARE @Return int				select @Return = 1 -- by default set for success
	DECLARE @kErrUserUpdate	int		select @kErrUserUpdate = -1
	DECLARE @kErrTransfer	int		select @kErrTransfer = -2
	DECLARE @kWarningBWS	int		select @kWarningBWS = 2 -- Not exactly an error, we need to notify user if on a BWS


	select @CurrentDate = GETUTCDATE()

	-- strip times from StartDate and EndDate because we are comparing with WorkDate	 
	select @StartDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), @StartDate, 101)), 101)
	select @EndDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), @EndDate, 101)), 101)

    -- Just query using UserKey i.e no CompanyKey
	select @OldTitleID = ISNULL(t.TitleID, '')
		 , @OldTitleKey = ISNULL(t.TitleKey, 0)
		 , @ActionOnName = ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')
	  from tUser u (nolock)
	   LEFT JOIN tTitle t (nolock) on u.TitleKey = t.TitleKey
	 where u.UserKey = @ActionOnUserKey
   
	if LEN(@ActionOnName) = 0
		select @ActionOnName = '(' + CAST(@ActionOnUserKey as varchar(7)) + ')'

	select @ActionByName = ISNULL(FirstName + ' ' + LastName, '')
	      ,@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
	  from tUser (nolock)
	 where UserKey = @UserKey

	select @TitleID = TitleID
	  from tTitle (nolock) 
	 where TitleKey = @TitleKey

-- create temp table now before beginning the transaction to prevent locking tempdb
-- I need a TimeID identity because I cannot loop using TimeKey
create table #time (TimeID int identity(1,1), TimeKey uniqueidentifier null, ProjectKey int null, TaskKey int null
					, WorkDate smalldatetime null, TransferToKey uniqueidentifier null, InvoiceLineKey int null, WriteOff int null,OnBWS int null)
if @UpdateEntries = 1
begin
	insert #time (TimeKey, ProjectKey, TaskKey, WorkDate, TransferToKey, InvoiceLineKey, WriteOff, OnBWS)
	select TimeKey, ProjectKey, TaskKey, WorkDate, TransferToKey, InvoiceLineKey, WriteOff, 0
	from   tTime (nolock)
	where  UserKey = @ActionOnUserKey 
	and    WorkDate >= @StartDate 
	and    WorkDate <= @EndDate 

	-- do not take time entries if they are already transferred or invoiced 
	delete #time where TransferToKey is not null or isnull(InvoiceLineKey,0) > 0

	-- do not take time entries marked as billed or written off
	delete #time where InvoiceLineKey = 0 or WriteOff = 1

	update #time
	set    #time.OnBWS = 1
	from   tBillingDetail bd (nolock)
	where  #time.TimeKey = bd.EntityGuid
	and    bd.Entity = 'tTime'

	if exists (select 1 from #time where OnBWS = 1)
		select @Return = @kWarningBWS

	delete #time where OnBWS = 1 -- we do not process if on a BWS
end
	
begin transaction

	if @OldTitleKey <> @TitleKey
	BEGIN
		update tUser 
		   set TitleKey = @TitleKey
		 where UserKey = @ActionOnUserKey
		   
		if @@ERROR <> 0 
		begin
			rollback transaction
			RETURN @kErrUserUpdate					   	
		end

		if @TitleKey > 0
		begin
			delete tUserService where  UserKey = @ActionOnUserKey

			if @@ERROR <> 0 
			begin
				rollback transaction
				RETURN @kErrUserUpdate					   	
			end

			insert tUserService (UserKey, ServiceKey)
			select @ActionOnUserKey, ts.ServiceKey
			from   tTitleService ts (nolock)
			where  ts.TitleKey = @TitleKey
			 
			if @@ERROR <> 0 
			begin
				rollback transaction
				RETURN @kErrUserUpdate					   	
			end

		end

		select @Msg = 'Billing Title for ' + @ActionOnName + ' was updated from ''' + @OldTitleID + ''' to ''' + @TitleID + ''''
        
		EXEC sptActionLogInsert 'User', @ActionOnUserKey, @CompanyKey, 0, 'Billing Title Updated', @CurrentDate, @ActionByName
							   ,@Msg, @ActionOnName, null, @UserKey   
	END
	
	if @UpdateEntries = 1
	BEGIN
		select @MsgStartDate = Cast(DatePart(mm,@StartDate) as varchar) + '/' + Cast(DatePart(dd,@StartDate) as varchar) + '/' + Cast(DatePart(yyyy,@StartDate) as varchar)
		select @MsgEndDate = Cast(DatePart(mm,@EndDate) as varchar) + '/' + Cast(DatePart(dd,@EndDate) as varchar) + '/' + Cast(DatePart(yyyy,@EndDate) as varchar)

		select @Msg = 'Time Entries for ' + @ActionOnName + ' from ''' + @MsgStartDate + ''' to ''' + @MsgEndDate + ''' were adjusted using Billing Title ''' + @TitleID + ''''

		EXEC sptActionLogInsert 'User', @ActionOnUserKey, @CompanyKey, 0, 'Time Entries Adjusted', @CurrentDate, @ActionByName
							    ,@Msg, @ActionOnName, null, @UserKey   


		declare @TimeID int
		declare @TimeKey uniqueidentifier
		declare @ProjectKey int
		declare @TaskKey int
		declare @WorkDate smalldatetime
		declare @RetVal int
		declare @IsAdjustment int
		declare @TransferToKey uniqueidentifier

		select @IsAdjustment = 2 -- this is an adjustment, not a transfer

		select @TimeID = -1
		while (1=1)
		begin
			select @TimeID = min(TimeID)
			from   #time
			where  TimeID > @TimeID

			if @TimeID is null
				break

			select @TimeKey = TimeKey
			      ,@ProjectKey = ProjectKey
				  ,@TaskKey = TaskKey
				  ,@WorkDate = WorkDate
			from   #time
			where  TimeID = @TimeID
			
			exec @RetVal = spProcessTranTransferTI @TimeKey,@ProjectKey,@TaskKey,@WorkDate,@Msg, @Msg, @TitleKey, @IsAdjustment, @TransferToKey output  
 
			if @RetVal <0
			begin
				rollback transaction
				RETURN @kErrTransfer					   	
			end
		
		end
		
	END
	
commit transaction
	 

	-- This can be done after the transaction, this is the project rollup
	select @ProjectKey = -1
	while (1=1)
	begin
		select @ProjectKey = min(ProjectKey)
		from   #time
		where  ProjectKey > @ProjectKey

		if @ProjectKey is null
			break

		-- rollup for Labor (1) and all types
		exec sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 1, 1
	end
	
	
	RETURN @Return
GO
