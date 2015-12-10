USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetVoucherDetail]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGetVoucherDetail]
	@VoucherKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 09/20/11 MFT 10.548  Created for new Voucher entry
|| 11/28/11 GHL 10.550  Changed tm.* to tm.TimeKey to increase perfo
|| 12/30/11 GHL 10.551  Added WorkDate/ActualHours/CostRate/DateBilled
|| 11/05/13 GHL 10.573  Added HCostRate so that we can recalculate CostRate in the UI
||                      if we change the exchange rate on the voucher
*/

SELECT
	cast(tm.TimeKey as varchar(250)) as TimeKey, -- varchar because Flex removes dashes 
	u.FirstName + ' ' + u.LastName AS Person,
	u.UserKey,
	p.ProjectKey,
	p.ProjectNumber,
	p.ProjectName,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	s.ServiceKey,
	s.ServiceCode,
	s.Description AS Service,
	
	tm.DateBilled,
	tm.WorkDate,
	tm.ActualHours,
	tm.HCostRate,
	tm.CostRate,
	ROUND(tm.ActualHours * tm.CostRate, 2) AS TotalCost
FROM
	tTime tm (nolock)
	INNER JOIN tUser u (nolock)
		ON tm.UserKey = u.UserKey
	LEFT JOIN tProject p (nolock)
		ON tm.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock)
		ON tm.TaskKey = t.TaskKey
	LEFT JOIN tService s (nolock)
		ON tm.ServiceKey = s.ServiceKey
WHERE
	VoucherKey = @VoucherKey
GO
