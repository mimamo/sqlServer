USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRAddOnHand_SumQty]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRAddOnHand_SumQty] @invtid varchar (30), @SiteId VarChar(10), @TodayDate smalldatetime, @TodayPlusLeadTime smalldatetime
   As
	SELECT SUM(ISNULL(QtyDesired, 0))
		FROM IRAddOnHand
	WHERE
		InvtID = @InvtID AND
		SiteID = @SiteID AND
		OnDate >= @TodayDate AND
		OnDate <= @TodayPlusLeadTime
GO
