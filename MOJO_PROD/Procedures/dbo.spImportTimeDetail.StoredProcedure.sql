USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportTimeDetail]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spImportTimeDetail]
(
 @CompanyKey int,
 @TimeSheetKey int,
 @SystemID varchar(500),
 @ProjectNumber varchar(50),
 @TaskID varchar(30),
 @ServiceID varchar(50),
 @WorkDate smalldatetime,
 @ActualHours decimal(9,3),
 @ActualRate money,
 @CostRate money,
 @BilledHours decimal(9,3),
 @BilledRate money,
 @Comments varchar(300),
 @RateLevel int,
 @Billed tinyint,
 @WriteOff tinyint
)
AS --Encrypt

DECLARE @GetRateFrom smallint,
   @OverrideRate tinyint,
   @TimeKey uniqueidentifier,
   @TimeRateSheetKey int,
   @RateSheetRate money,
   @UserKey int, 
   @ProjectKey int, 
   @TaskKey int, 
   @ServiceKey int,
   @InvoiceLineKey int

/*
|| When      Who Rel     What
|| 10/25/07   RLB 8.4.3.9 (14715) Removed TaskType restriction on Task validation.
*/   

-- Validations ************************************
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
	
	if @TaskID is null
		return -3
		
	Select @TaskKey = TaskKey from tTask (nolock) Where TaskID = @TaskID and ProjectKey = @ProjectKey and TrackBudget = 1
		if @TaskKey is null
			return -4

	if exists(Select 1 from tProject (nolock) Where ProjectKey = @ProjectKey and Closed = 1)
		return -7
		
	if exists(Select 1 from tProject p (nolock) inner join tProjectStatus ps on p.ProjectStatusKey = ps.ProjectStatusKey
		Where p.ProjectKey = @ProjectKey and ps.TimeActive = 0)
		return -7

end 

if @ServiceID is not null
BEGIN
	Select @ServiceKey = ServiceKey from tService (nolock) Where ServiceCode = @ServiceID and CompanyKey = @CompanyKey
	if @ServiceKey is null
		return -5
END

if @RateLevel is null
	Select @RateLevel = 1


-- Get Rates if needed
if @CostRate is null
 SELECT @CostRate = ISNULL(HourlyCost, 0)
 FROM   tUser (NOLOCK)
 WHERE  UserKey = @UserKey
 

if isnull(@WriteOff, 0) = 1
	Select @BilledHours = 0, @BilledRate = 0, @InvoiceLineKey = NULL
else
begin
	if isnull(@Billed, 0) = 1
	begin
		Select @BilledHours = isnull(@BilledHours, isnull(@ActualHours, 0)),
		 @BilledRate = isnull(@BilledRate, isnull(@ActualRate, 0)),
		 @InvoiceLineKey = 0
	end
end



INSERT tTime
  (
  TimeKey,
  TimeSheetKey,
  UserKey,
  ProjectKey,
  TaskKey,
  ServiceKey,
  RateLevel,
  WorkDate,
  ActualHours,
  ActualRate,
  BilledHours,
  BilledRate,
  InvoiceLineKey,
  WriteOff,
  Comments,
  CostRate)
 VALUES
  (
  NEWID(),
  @TimeSheetKey,
  @UserKey,
  @ProjectKey,
  @TaskKey,
  @ServiceKey,
  @RateLevel,
  @WorkDate,
  isnull(@ActualHours, 0),
  isnull(@ActualRate, 0),
  isnull(@BilledHours, 0),
  isnull(@BilledRate, 0),
  @InvoiceLineKey,
  isnull(@WriteOff, 0),
  @Comments,
  isnull(@CostRate, 0)
  )
 
 RETURN 1
GO
