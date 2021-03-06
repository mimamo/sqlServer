USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPLaborPartialWriteOff]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPLaborPartialWriteOff]
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
  */

	SET NOCOUNT ON 


	declare @NewTimeKey uniqueidentifier

	select @NewTimeKey = NEWID()
	 
  	begin transaction

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
	     
	commit tran

	-- do this outside of the SQL transaction, this is just a rollup
	Declare @ProjectKey int
	select @ProjectKey = ProjectKey from tTime (nolock) where TimeKey = @TimeKey
	if isnull(@ProjectKey, 0) > 0 
		EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 1, 1

	RETURN 1
GO
