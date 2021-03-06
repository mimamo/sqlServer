USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphWriteOffSummary]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphWriteOffSummary]

	(
		@CompanyKey int,
		@OfficeKey int,
		@DepartmentKey int,
		@UserKey int,
		@Range varchar(100),
		@Mode smallint
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/3/07  GWG 8.4.3 Fixed getting year to date calc
  || 01/28/10 RLB 10517 (73272) Changed Yeat to Date to FirstMonth <= Todays month
  || 04/01/15 GHL 10591 Specified source of DepartmentKey (ambiguous error)
  */
  
Declare @StartDate smalldatetime, @EndDate smalldatetime, @FirstMonth int

if @Range = 'All Time'
	Select @StartDate = DateAdd(yyyy, -20, GETDATE()), @EndDate = DateAdd(yyyy, 20, GETDATE())

if @Range = 'Year to Date'
BEGIN
	
	Select @FirstMonth = ISNULL(FirstMonth, 1) from tPreference (nolock) Where CompanyKey = @CompanyKey
	
	if @FirstMonth <= Month(GETDATE())
		Select @StartDate = Cast(Cast(@FirstMonth as varchar) + '/1/' + Cast(Year(GETDATE()) as varchar) as smalldatetime), @EndDate = GETDATE()
	else
		Select @StartDate = Cast(Cast(@FirstMonth as varchar) + '/1/' + Cast(Year(GETDATE()) - 1 as varchar) as smalldatetime), @EndDate = GETDATE()
END

if @Range = 'Last 6 Months'
	Select @StartDate = DateAdd(mm, -6, GETDATE()), @EndDate = GETDATE()

if @Mode = 1
	Select 
		Sum(ROUND(tTime.ActualHours * tTime.ActualRate, 2)) as Amount,
		ReasonName
	From
		tTime (nolock)
		inner join tTimeSheet (nolock) on tTimeSheet.TimeSheetKey = tTime.TimeSheetKey
		left outer join tWriteOffReason (nolock) on tTime.WriteOffReasonKey = tWriteOffReason.WriteOffReasonKey
	Where
		tTimeSheet.CompanyKey = @CompanyKey and
		tTime.WriteOff = 1 and
		WorkDate >= @StartDate and
		WorkDate <= @EndDate
	Group By 
		ReasonName
	Order By Amount DESC
	
else if @Mode = 2
	Select 
		Sum(ROUND(tTime.ActualHours * tTime.ActualRate, 2)) as Amount,
		ReasonName
	From
		tTime (nolock)
		inner join tUser (nolock) on tUser.UserKey = tTime.UserKey
		inner join tTimeSheet (nolock) on tTimeSheet.TimeSheetKey = tTime.TimeSheetKey
		left outer join tWriteOffReason (nolock) on tTime.WriteOffReasonKey = tWriteOffReason.WriteOffReasonKey
	Where
		tTimeSheet.CompanyKey = @CompanyKey and
		tTime.WriteOff = 1 and
		WorkDate >= @StartDate and
		WorkDate <= @EndDate and
		OfficeKey = @OfficeKey
	Group By 
		ReasonName
	Order By Amount DESC
	
else if @Mode = 3
	Select 
		Sum(ROUND(tTime.ActualHours * tTime.ActualRate, 2)) as Amount,
		ReasonName
	From
		tTime (nolock)
		inner join tUser (nolock) on tUser.UserKey = tTime.UserKey
		inner join tTimeSheet (nolock) on tTimeSheet.TimeSheetKey = tTime.TimeSheetKey
		left outer join tWriteOffReason (nolock) on tTime.WriteOffReasonKey = tWriteOffReason.WriteOffReasonKey
	Where
		tTimeSheet.CompanyKey = @CompanyKey and
		tTime.WriteOff = 1 and
		WorkDate >= @StartDate and
		WorkDate <= @EndDate and
		OfficeKey = @OfficeKey and
		tUser.DepartmentKey = @DepartmentKey
	Group By 
		ReasonName
	Order By Amount DESC
	
else if @Mode = 4
	Select 
		Sum(ROUND(tTime.ActualHours * tTime.ActualRate, 2)) as Amount,
		ReasonName
	From
		tTime (nolock)
		inner join tTimeSheet (nolock) on tTimeSheet.TimeSheetKey = tTime.TimeSheetKey
		left outer join tWriteOffReason (nolock) on tTime.WriteOffReasonKey = tWriteOffReason.WriteOffReasonKey
	Where
		tTimeSheet.CompanyKey = @CompanyKey and
		tTime.WriteOff = 1 and
		WorkDate >= @StartDate and
		WorkDate <= @EndDate and
		tTime.UserKey = @UserKey
	Group By 
		ReasonName
	Order By Amount DESC
GO
