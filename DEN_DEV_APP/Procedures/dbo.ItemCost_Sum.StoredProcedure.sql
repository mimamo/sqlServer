USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_Sum]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemCost_Sum    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemCost_Sum    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemCost_Sum] @parm1 varchar ( 30), @parm2 varchar (  10),  @parm3 varchar ( 15) as
Select Sum(Qty), Sum(TotCost), Sum(BMITotCost) from
        ItemCost where InvtId = @parm1 and SiteId = @parm2
GO
