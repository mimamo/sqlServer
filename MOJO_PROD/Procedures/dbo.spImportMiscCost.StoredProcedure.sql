USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportMiscCost]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportMiscCost]
	@CompanyKey int,
	@ProjectNumber varchar(50),
	@TaskID varchar(30),
	@ExpenseDate smalldatetime,
	@ShortDescription varchar(200),
	@LongDescription varchar(1000),
	@ItemID varchar(50),
	@Quantity decimal(9,3),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Markup decimal(9,3),
	@BillableAmount money,
	@AmountBilled money,
	@EnteredByKey int, 
	@Billed tinyint,
	@WriteOff tinyint,
	@ClassID varchar(50)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/26/07 GHL 8.42   Changed validation of TaskKey
  || 06/15/10 GWG 10.5.3.1 Added date billed when billed or write off is 1
  */
  
Declare @ProjectKey int, @TaskKey int, @ItemKey int, @InvoiceLineKey int, @Billable tinyint
Declare @RequireClasses int, @RequireTasks int, @ClassKey int, @DateBilled smalldatetime

Select @RequireClasses = ISNULL(RequireClasses, 0)
		,@RequireTasks = ISNULL(RequireTasks, 1)
from   tPreference (NOLOCK)
where  CompanyKey = @CompanyKey

Select @ProjectKey = ProjectKey from tProject (nolock) Where ProjectNumber = @ProjectNumber and CompanyKey = @CompanyKey and Closed = 0
if @ProjectKey is null
	return -1


if @RequireTasks = 1 and @TaskID is null
	return -2
	
Select @TaskKey = TaskKey from tTask (nolock) 
	Where TaskID = @TaskID 
	and ProjectKey = @ProjectKey 
	and TrackBudget = 1 
if @RequireTasks = 1 and @TaskKey is null
	return -3
			
if @ItemID is not null
BEGIN

	Select @ItemKey = ItemKey from tItem (nolock) Where ItemID = @ItemID and CompanyKey = @CompanyKey
	if @ItemKey is null
		return -4

	if exists(Select 1 from tPreference pre (nolock) inner join tProject pro (nolock) on pre.CompanyKey = pro.CompanyKey Where pro.ProjectKey = @ProjectKey and pre.TrackQuantityOnHand = 1)
	BEGIN

		Declare @CurItemQty decimal(9, 3)

		if ISNULL(@ItemKey, 0) > 0
		begin
			Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
			Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey

		end
	END

END

if @ClassID is not null
	select @ClassKey = ClassKey from tClass (nolock) where ClassID = @ClassID and CompanyKey = @CompanyKey
	
if @RequireClasses = 1 and @ClassKey is null
	return -6

if exists(Select 1 from tProject (nolock) Where ProjectKey = @ProjectKey and Closed = 1)
	return -5
	
if exists(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 0)
	return -5

if @BillableAmount = 0 
	Select @BillableAmount = @TotalCost * (1 + (@Markup / 100.0))
If @Markup = 0 and @TotalCost > 0 
	Select @Markup = ((@BillableAmount - @TotalCost) / @TotalCost) * 100

if @BillableAmount > 0 
	Select @Billable = 1
else
	select @Billable = 0

if isnull(@WriteOff, 0) = 1
	Select @AmountBilled = 0, @InvoiceLineKey = NULL, @DateBilled = dbo.fFormatDateNoTime(GETDATE())
else
begin
	if isnull(@Billed, 0) = 1
	begin
		Select @AmountBilled = isnull(@AmountBilled, isnull(@BillableAmount, 0)), @DateBilled = dbo.fFormatDateNoTime(GETDATE()),
		 @InvoiceLineKey = 0
	end
end


INSERT tMiscCost
	(
	ProjectKey,
	TaskKey,
	ExpenseDate,
	ShortDescription,
	LongDescription,
	ItemKey,
	Quantity,
	UnitCost,
	UnitDescription,
	TotalCost,
	UnitRate,
	Markup,
	Billable,
	BillableCost,
	AmountBilled,
	EnteredByKey,
	DateEntered,
	InvoiceLineKey,
	DateBilled,
	WriteOff,
	ClassKey
	)

VALUES
	(
	@ProjectKey,
	@TaskKey,
	@ExpenseDate,
	@ShortDescription,
	@LongDescription,
	@ItemKey,
	@Quantity,
	@UnitCost,
	@UnitDescription,
	@TotalCost,
	@UnitRate,
	@Markup,
	@Billable,
	@BillableAmount,
	@AmountBilled,
	@EnteredByKey,
	GETDATE(),
	@InvoiceLineKey,
	@DateBilled,
	@WriteOff,
	@ClassKey
	)


	RETURN 1
GO
