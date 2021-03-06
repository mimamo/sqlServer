USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRPlanOrd_SumQty]    Script Date: 12/16/2015 15:55:23 ******/
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
