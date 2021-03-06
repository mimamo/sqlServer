USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRPlanOrd_SumQty]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRPlanOrd_SumQty] @invtid varchar (30), @SiteId VarChar(10)
   As
	SELECT SUM(ISNULL(PlanQty, 0))
		FROM IRPlanOrd
	WHERE
		InvtID = @InvtID AND
		SiteID = @SiteID AND
		Status = 'FI'
GO
