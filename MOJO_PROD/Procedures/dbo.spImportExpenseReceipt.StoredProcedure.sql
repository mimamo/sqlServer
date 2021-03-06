USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportExpenseReceipt]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportExpenseReceipt]
 @CompanyKey int,
 @ExpenseEnvelopeKey int,
 @SystemID varchar(500),
 @ExpenseDate smalldatetime,
 @ExpenseTypeID varchar(50),    -- Now ItemID
 @ProjectNumber varchar(50),
 @TaskID varchar(30),
 @ActualQty decimal(9,3),
 @ActualUnitCost money,
 @ActualCost money,
 @Description varchar(100),
 @Comments varchar(500),
 @Markup decimal(9,3),
 @BillableAmount money,
 @AmountBilled money,
 @Billed tinyint,
 @WriteOff tinyint
 
AS --Encrypt

/*
|| When     Who Rel   What
|| 07/10/07 QMD/GHL 8.5   Expense Type reference changed to tItem
*/

declare @UserKey int,@ItemKey int,@ProjectKey int,@TaskKey int,@InvoiceLineKey int,  @Billable tinyint, @RequireTasks int

select @RequireTasks = isnull(RequireTasks, 1) from tPreference (nolock) where CompanyKey = @CompanyKey

Select @UserKey = UserKey from tUser (nolock) Where SystemID = @SystemID and ISNULL(OwnerCompanyKey, CompanyKey) = @CompanyKey and Active = 1 and Len(UserID) > 0
	if @UserKey is null
		return -1
		
if @ProjectNumber is not null
begin
	Select @ProjectKey = ProjectKey from tProject (nolock) Where ProjectNumber = @ProjectNumber and CompanyKey = @CompanyKey and Closed = 0
	if @ProjectKey is null
		return -2
		
	If not exists(Select 1 from tAssignment (nolock) Where UserKey = @UserKey and ProjectKey = @ProjectKey)
		Return -6
		
	if @TaskID is null and @RequireTasks = 1
		return -3
		
	Select @TaskKey = TaskKey from tTask (nolock) Where TaskID = @TaskID and ProjectKey = @ProjectKey and MoneyTask = 1 and TaskType = 2
		if @TaskKey is null and @RequireTasks = 1
			return -4
			
	if exists(Select 1 from tProject (nolock) Where ProjectKey = @ProjectKey and Closed = 1)
		return -7
		
	if exists(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
		Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 0)
		return -7
end 

Select @ItemKey = ItemKey from tItem (nolock) Where ItemID = @ExpenseTypeID and CompanyKey = @CompanyKey
if @ItemKey is null
	return -5
		
if @ProjectKey is not null
begin
	if @BillableAmount = 0 
		Select @BillableAmount = @ActualCost * (1 + (@Markup / 100.0))
	If @Markup = 0 and @ActualCost > 0 
		Select @Markup = Round(((@BillableAmount - @ActualCost) / @ActualCost) * 100, 2)

end

if isnull(@WriteOff, 0) = 1
	Select @AmountBilled = 0, @InvoiceLineKey = NULL
else
begin
	if isnull(@Billed, 0) = 1
	begin
		Select @AmountBilled = isnull(@AmountBilled, isnull(@BillableAmount, 0)),
		 @InvoiceLineKey = 0
	end
end

if @AmountBilled > 0 
	Select @Billable = 1
else
	Select @Billable = 0

		
 INSERT tExpenseReceipt
  (
  ExpenseEnvelopeKey,
  UserKey,
  ExpenseDate,
  ItemKey,
  ProjectKey,
  TaskKey,
  PaperReceipt,
  ActualQty,
  ActualUnitCost,
  ActualCost,
  Description,
  Comments,
  Markup,
  Billable,
  BillableCost,
  InvoiceLineKey,
  WriteOff
  )
 VALUES
  (
  @ExpenseEnvelopeKey,
  @UserKey,
  @ExpenseDate,
  @ItemKey,
  @ProjectKey,
  @TaskKey,
  0,
  @ActualQty,
  @ActualUnitCost,
  @ActualCost,
  @Description,
  @Comments,
  @Markup,
  @Billable,
  @BillableAmount,
  @InvoiceLineKey,
  @WriteOff
  )
 
 RETURN 1
GO
