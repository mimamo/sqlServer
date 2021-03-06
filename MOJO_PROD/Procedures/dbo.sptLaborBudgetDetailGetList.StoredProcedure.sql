USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetDetailGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetDetailGetList]

	@LaborBudgetKey int


AS --Encrypt

		SELECT lb.*,
			u.FirstName,
			u.LastName,
			u.DepartmentKey,
			ISNULL(d.DepartmentName, ' No Department') as DepartmentName,
			u.OfficeKey,
			ISNULL(o.OfficeName, ' No Office') as OfficeName,
			ISNULL(lb.AvailableHours1, 0) + ISNULL(lb.AvailableHours2, 0) + ISNULL(lb.AvailableHours3, 0) + ISNULL(lb.AvailableHours4, 0) + ISNULL(lb.AvailableHours5, 0) + ISNULL(lb.AvailableHours6, 0) + ISNULL(lb.AvailableHours7, 0) + ISNULL(lb.AvailableHours8, 0) + ISNULL(lb.AvailableHours9, 0) + ISNULL(lb.AvailableHours10, 0) + ISNULL(lb.AvailableHours11, 0) + ISNULL(lb.AvailableHours12, 0) as AvailableHours,
			ISNULL(lb.TargetHours1, 0) + ISNULL(lb.TargetHours2, 0) + ISNULL(lb.TargetHours3, 0) + ISNULL(lb.TargetHours4, 0) + ISNULL(lb.TargetHours5, 0) + ISNULL(lb.TargetHours6, 0) + ISNULL(lb.TargetHours7, 0) + ISNULL(lb.TargetHours8, 0) + ISNULL(lb.TargetHours9, 0) + ISNULL(lb.TargetHours10, 0) + ISNULL(lb.TargetHours11, 0) + ISNULL(lb.TargetHours12, 0) as TargetHours,
			ISNULL(lb.TargetDollars1, 0) + ISNULL(lb.TargetDollars2, 0) + ISNULL(lb.TargetDollars3, 0) + ISNULL(lb.TargetDollars4, 0) + ISNULL(lb.TargetDollars5, 0) + ISNULL(lb.TargetDollars6, 0) + ISNULL(lb.TargetDollars7, 0) + ISNULL(lb.TargetDollars8, 0) + ISNULL(lb.TargetDollars9, 0) + ISNULL(lb.TargetDollars10, 0) + ISNULL(lb.TargetDollars11, 0) + ISNULL(lb.TargetDollars12, 0) as TargetDollars
			
		FROM tLaborBudgetDetail lb (nolock)
			inner join tUser u (nolock) on lb.UserKey = u.UserKey
			left outer join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
			left outer join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
		WHERE
			LaborBudgetKey = @LaborBudgetKey
	RETURN 1
GO
