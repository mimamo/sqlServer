USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_AllDMG]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDPackIndicator_AllDMG] @IndicatorTypeMin smallint, @IndicatorTypeMax smallint, @InvtId varchar(30), @PackIndicator varchar(1) As
Select * From EDPackIndicator Where IndicatorType Between @IndicatorTypeMin And @IndicatorTypeMax
And InvtId Like @InvtId And PackIndicator Like @PackIndicator
Order By IndicatorType, InvtId, PackIndicator
GO
