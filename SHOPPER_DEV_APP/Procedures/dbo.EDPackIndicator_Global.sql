USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_Global]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPackIndicator_Global] @PackIndicator varchar(1) As
Select * From EDPackIndicator Where IndicatorType = 1 And PackIndicator Like @PackIndicator Order By IndicatorType, InvtId, PackIndicator
GO
