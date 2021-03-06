USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicate_GetIndicator]    Script Date: 12/21/2015 16:01:00 ******/
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
