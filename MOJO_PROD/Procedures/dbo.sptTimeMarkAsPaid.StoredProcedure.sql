USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeMarkAsPaid]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeMarkAsPaid]
	(
	@CompanyKey int
	,@UserKey int
	,@StartDate datetime
	,@EndDate datetime
	,@Paid tinyint
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 02/07/12 GHL 10.552  Created for new Voucher entry functionality
|| 05/30/12 GHL 10.556  (145013) Added Contractor filter
*/
	SET NOCOUNT ON

	-- VoucherKey = null	unpaid
	-- VoucherKey = 0		marked as paid
	-- VoucherKey > 0		paid

	if isnull(@UserKey, 0) > 0
	begin
		if @Paid = 1
			-- mark them as paid
			update tTime
			set    VoucherKey = 0
			where  UserKey = @UserKey
			and    (@StartDate is null or WorkDate >= @StartDate)
			and    (@EndDate is null or WorkDate <= @EndDate)
			and    VoucherKey is null 
		else
			-- mark them as unpaid
			update tTime
			set    VoucherKey = null
			where  UserKey = @UserKey
			and    (@StartDate is null or WorkDate >= @StartDate)
			and    (@EndDate is null or WorkDate <= @EndDate)
			and    VoucherKey = 0 
	end
	else 
	begin
		if @Paid = 1
			-- mark them as paid
			update tTime
			set    tTime.VoucherKey = 0
			from   tTimeSheet ts (nolock)
			      ,tUser u (nolock)
			where  ts.CompanyKey = @CompanyKey
			and    ts.TimeSheetKey = tTime.TimeSheetKey
			and    u.UserKey = tTime.UserKey
			and    u.Contractor = 1
			and    (@StartDate is null or tTime.WorkDate >= @StartDate)
			and    (@EndDate is null or tTime.WorkDate <= @EndDate)
			and    tTime.VoucherKey = null
			  
		else
			-- mark them as unpaid
			update tTime
			set    tTime.VoucherKey = null
			from   tTimeSheet ts (nolock)
			      ,tUser u (nolock)
			where  ts.CompanyKey = @CompanyKey
			and    ts.TimeSheetKey = tTime.TimeSheetKey
			and    u.UserKey = tTime.UserKey
			and    u.Contractor = 1
			and    (@StartDate is null or tTime.WorkDate >= @StartDate)
			and    (@EndDate is null or tTime.WorkDate <= @EndDate)
			and    tTime.VoucherKey = 0 
	
	end
	 
	RETURN 1
GO
