USE [MID_DEV_APP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[xvr_PA924_PO]

as

/*******************************************************************************************************
*	MID_DEV_APP.dbo.xvr_PA924_PO.sql
*
*   Notes:  


	select *
	from MID_DEV_APP.dbo.xvr_PA924_PO
	where projectId in('00583814AGY', -- incorrect
					'00383813AGY')	-- correct

	SELECT p.ProjectID,
		ExtCost = CuryExtCost,
		CostVouched = CuryCostVouched, *
	FROM MID_DEV_APP.dbo.PurOrdDet p 
	inner join MID_DEV_APP.dbo.PurchOrd po 
		on p.PONbr = po.PONbr
	where p.projectId in('00583814AGY', '00427814AGY', '00572314AGY', -- incorrect
					'00383813AGY','00515814AGY', '00492114AGY', '00517714AGY')	-- correct	
	order by p.projectId
*                  
*   Modifications:   
*   Name				Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/

SELECT p.ProjectID,
	ExtCost = sum(CuryExtCost),
	CostVouched = sum(CuryCostVouched)
FROM MID_DEV_APP.dbo.PurOrdDet p 
inner join MID_DEV_APP.dbo.PurchOrd po 
	on p.PONbr = po.PONbr
WHERE po.status in ('O', 'P')
GROUP BY p.ProjectID


GO
