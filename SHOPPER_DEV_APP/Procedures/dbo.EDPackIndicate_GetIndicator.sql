USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicate_GetIndicator]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPackIndicate_GetIndicator] @InvtId varchar(30), @Qty float As
	Select PackIndicator
	From EDPackIndicator
	Where InvtId In (@InvtId, '*') And ContainerQty = @Qty
	Order By IndicatorType Desc
GO
