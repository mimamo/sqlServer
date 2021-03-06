USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMiscCostInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMiscCostInsert]
	@ProjectKey int,
	@TaskKey int,
	@ExpenseDate smalldatetime,
	@ShortDescription varchar(200),
	@LongDescription varchar(1000),
	@ItemKey int,
	@DepartmentKey int,
	@ClassKey int,
	@Quantity decimal(24,4),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Markup decimal(24,4),
	@Billable int,
	@BillableCost money,
	@EnteredByKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

 /*
  || When     Who Rel   What
  || 02/15/07 GHL 8.4   Added project rollup section 
  || 10/05/07 GWG 8.5   Added Department 
  */
if exists(Select 1 from tProject p (nolock) Where ProjectKey = @ProjectKey and Closed = 1)
	return -1
	
if exists(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey Where ProjectKey = @ProjectKey and ExpenseActive = 0)
	return -2
	
if exists(Select 1 from tPreference pre (nolock) inner join tProject pro (nolock) on pre.CompanyKey = pro.CompanyKey Where pro.ProjectKey = @ProjectKey and pre.TrackQuantityOnHand = 1)
BEGIN

	Declare @CurItemQty decimal(9, 3)

	if ISNULL(@ItemKey, 0) > 0
	begin
		Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
		Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey

	end
END
			INSERT tMiscCost
				(
				ProjectKey,
				TaskKey,
				ExpenseDate,
				ShortDescription,
				LongDescription,
				ItemKey,
				DepartmentKey,
				ClassKey,
				Quantity,
				UnitCost,
				UnitDescription,
				TotalCost,
				UnitRate,
				Markup,
				Billable,
				BillableCost,
				EnteredByKey,
				DateEntered
				)

			VALUES
				(
				@ProjectKey,
				@TaskKey,
				@ExpenseDate,
				@ShortDescription,
				@LongDescription,
				@ItemKey,
				@DepartmentKey,
				@ClassKey,
				@Quantity,
				@UnitCost,
				@UnitDescription,
				@TotalCost,
				@UnitRate,
				@Markup,
				@Billable,
				@BillableCost,
				@EnteredByKey,
				GETDATE()
				)
		SELECT @oIdentity = @@IDENTITY

	DECLARE	@TranType INT,@BaseRollup INT,@Approved INT,@Unbilled INT,@WriteOff INT
	SELECT	@TranType = 2,@BaseRollup = 1,@Approved = 0,@Unbilled = 1,@WriteOff = 0
	EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff
	
	RETURN 1
GO
