USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingScheduleUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingScheduleUpdate]
	@BillingScheduleKey int,
	@ProjectKey int,
	@NextBillDate smalldatetime,
	@TaskKey int,
	@Comments varchar(4000),
	@Action varchar(10) = 'update',
	@PercentBudget decimal(24,4) = null

AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/25/09 GHL 10.508 (58125) Rewrote using new standard Action param 
  || 01/25/13 GHL 10.564 (166323) Could not generate FF billing worksheet because NextBillDate and TaskKey is null
  ||                      Deleting now records if both fields are null      
  || 07/15/13 GHL 10.570 (182036) Added PercentBudget     
  || 11/17/14 GHL 10.586 (236560) Added update of forecast so that the user can regenerate the forecast project detail                        
  */
  
if @NextBillDate is null and isnull(@TaskKey, 0) = 0
	select @Action = 'delete'

if isnull(@PercentBudget, 0) <= 0
	select @PercentBudget = null

if isnull(@PercentBudget, 0) > 100
	select @PercentBudget = 100

if isnull(@PercentBudget, 0) > 0
	select @PercentBudget = round(@PercentBudget, 2)


update tForecastDetail
set    tForecastDetail.RegenerateNeeded = 1
where  Entity in ('tProject-Approved', 'tProject-Potential')
and    EntityKey = @ProjectKey

if @Action = 'delete'
BEGIN
						
	DELETE
	FROM  tBillingSchedule
	WHERE BillingScheduleKey = @BillingScheduleKey 
	
	Return 0
END
ELSE
BEGIN

	IF @BillingScheduleKey <= 0
	BEGIN
		INSERT tBillingSchedule
			(
			ProjectKey,
			NextBillDate,
			TaskKey,
			Comments,
			PercentBudget
			)

		VALUES
			(
			@ProjectKey,
			@NextBillDate,
			@TaskKey,
			@Comments,
			@PercentBudget
			)
		
		return @@IDENTITY
	END
	ELSE
	BEGIN
	
		UPDATE
			tBillingSchedule
		SET
			ProjectKey = @ProjectKey,
			NextBillDate = @NextBillDate,
			TaskKey = @TaskKey,
			Comments = @Comments,
			PercentBudget = @PercentBudget
		WHERE
			BillingScheduleKey = @BillingScheduleKey 
		
		return @BillingScheduleKey
	
	END
	
END

	RETURN 1
GO
