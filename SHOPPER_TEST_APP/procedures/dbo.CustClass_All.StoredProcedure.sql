USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustClass_All]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustClass_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[CustClass_All] @parm1 varchar ( 6) as
    Select * from CustClass where ClassId like @parm1 order by ClassId
GO
