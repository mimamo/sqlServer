USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_Global]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPackIndicator_Global] @PackIndicator varchar(1) As
Select * From EDPackIndicator Where IndicatorType = 1 And PackIndicator Like @PackIndicator Order By IndicatorType, InvtId, PackIndicator
GO
