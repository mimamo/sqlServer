USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_GetContainerQty]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPackIndicator_GetContainerQty] @InvtId varchar(30), @PackIndicator varchar(1) As
Select ContainerQty From EDPackIndicator Where Invtid In (@InvtId, '*') And PackIndicator =
@PackIndicator Order By IndicatorType Desc
GO
