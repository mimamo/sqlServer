USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_ItemSpecific]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDPackIndicator_ItemSpecific] @InvtId varchar(30), @PackIndicator varchar(1) As
Select * From EDPackIndicator Where IndicatorType = 2 And InvtId Like @InvtId And PackIndicator Like @PackIndicator Order By IndicatorType, InvtId, PackIndicator
GO
