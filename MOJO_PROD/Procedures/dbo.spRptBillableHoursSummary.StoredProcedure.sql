USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptBillableHoursSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptBillableHoursSummary]
	(
	  @CompanyKey int
     ,@UserKey int
     ,@DepartmentKey int
	 ,@GroupByDept tinyint
	 ,@StartDate  smalldatetime
	 ,@EndDate  smalldatetime	)

AS --Encrypt

/*
|| When        Who Rel       What
|| 1004/2012  WDF 10.5.6.0 (150044 ) New Billable Hours Summary Report
*/
--
--  Temp table to hold Billable/Non-Billable Hours per User
--
	CREATE TABLE #userbillHrs
	(
	  UserKey              int
	 ,HrsBillable    decimal(6,2)
	 ,HrsNonBillable decimal(6,2)
	)

	INSERT #userbillHrs
	SELECT t.UserKey
		,CASE
		   WHEN ISNULL(p.NonBillable, 0) = 0 AND ISNULL(t.ActualRate, 0) > 0 THEN ISNULL(t.ActualHours, 0)
		   ELSE 0
		 END AS HrsBillable
		,CASE
		   WHEN ISNULL(p.NonBillable, 0) = 1 OR ISNULL(t.ActualRate, 0) = 0 THEN ISNULL(t.ActualHours, 0)
		   ELSE 0
		 END AS HrsNonBillable
      FROM tUser u (NOLOCK) INNER JOIN tTime       t  (NOLOCK) ON (u.UserKey      = t.UserKey)
						    INNER JOIN tProject    p  (NOLOCK) ON (p.ProjectKey   = t.ProjectKey)
						    INNER JOIN tCompany    c  (NOLOCK) ON (c.CompanyKey   = p.CompanyKey)
	 WHERE c.CompanyKey = @CompanyKey
	   AND LEN(ISNULL(LTRIM(RTRIM(ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,''))), '')) > 1   
       AND u.Active = 1
       AND (@UserKey = -1 OR u.UserKey = @UserKey)
	   AND (t.WorkDate >= @StartDate
	   AND  t.WorkDate <= @EndDate)
--
--  Temp table to hold summary of Billable/Non-Billable Hours per User
--
	CREATE TABLE #userSumHrs
	(
		 UserKey           int
		,FirstName         varchar(100)
		,LastName          varchar(100)
		,DepartmentKey     int
		,DepartmentName    varchar(200)
		,HrsBillable       decimal(6,2)
		,HrsPctBillable    decimal(4,1)
		,HrsNonBillable    decimal(6,2)
		,HrsPctNonBillable decimal(4,1)
		,HrsTotal          decimal(8,2)
	)	

	INSERT #userSumHrs
	SELECT UserKey, null, null, 0, null
          ,SUM(HrsBillable) AS TotHrsBill
          ,ISNULL(SUM(HrsBillable) / NULLIF(SUM(HrsBillable + HrsNonBillable), 0), 0) * 100 AS PctTotBill
          ,SUM(HrsNonBillable) AS TotHrsNonBill
          ,ISNULL(SUM(HrsNonBillable) / NULLIF(SUM(HrsBillable + HrsNonBillable), 0), 0) * 100 AS PctTotNonBill
          ,SUM(HrsBillable + HrsNonBillable) AS TOTHRS
      FROM #userbillHrs
    GROUP BY UserKey
--
--  Fill in missing User/Department info into Temp table
--
	UPDATE t
       SET t.FirstName      = u.FirstName
          ,t.LastName       = u.LastName
          ,t.DepartmentKey  = ISNULL(d.DepartmentKey, 0)
          ,t.DepartmentName = ISNULL(d.DepartmentName,'No Department')
      FROM #userSumHrs t INNER JOIN tUser       u (NOLOCK) ON (t.UserKey = u.UserKey)
                          LEFT JOIN tDepartment d (NOLOCK) ON (d.DepartmentKey = u.DepartmentKey)
	--
	--  Return either specific User, specific Department or all Users
	--
	IF @UserKey <> -1 OR @DepartmentKey <> -1
		BEGIN
			--
			--  Return Specific User only
			--
			IF @UserKey <> -1
				BEGIN
					SELECT UserKey, FirstName + ' ' + LastName AS [UserName]
						  ,DepartmentKey, DepartmentName
						  ,HrsBillable, HrsPctBillable, HrsNonBillable, HrsPctNonBillable, HrsTotal
					  FROM #userSumHrs
					 WHERE UserKey = @UserKey
				END
			ELSE
				--
				--  Return Specific Department only
				--
				BEGIN
					SELECT DepartmentKey AS [UserKey], DepartmentName AS [UserName]
						  ,0 AS [DepartmentKey], 0 AS [DepartmentName]
						  ,SUM(HrsBillable) AS HrsBillable
						  ,ISNULL(SUM(HrsBillable) / NULLIF(SUM(HrsBillable + HrsNonBillable), 0), 0) * 100 AS HrsPctBillable
						  ,SUM(HrsNonBillable) AS HrsNonBillable
						  ,ISNULL(SUM(HrsNonBillable) / NULLIF(SUM(HrsBillable + HrsNonBillable), 0), 0) * 100 AS HrsPctNonBillable
						  ,SUM(HrsBillable + HrsNonBillable) AS HrsTotal
					  FROM #userSumHrs
				     WHERE DepartmentKey = @DepartmentKey
					GROUP BY DepartmentKey, DepartmentName
				END
		END
	ELSE
		--
		--  Return all Users...how sorted will depend on whether grouped or not
		--
		BEGIN
			IF @GroupByDept = 0 
				BEGIN
					SELECT UserKey, FirstName + ' ' + LastName AS [UserName]
						  ,DepartmentKey, DepartmentName
						  ,HrsBillable, HrsPctBillable, HrsNonBillable, HrsPctNonBillable, HrsTotal
					  FROM #userSumHrs
					ORDER BY HrsPctBillable DESC, UserName
				END
			ELSE
				BEGIN
					SELECT UserKey, FirstName + ' ' + LastName AS [UserName]
						  ,DepartmentKey, DepartmentName
						  ,HrsBillable, HrsPctBillable, HrsNonBillable, HrsPctNonBillable, HrsTotal
					  FROM #userSumHrs
					ORDER BY DepartmentName, HrsPctBillable DESC, UserName
				END
		END
GO
