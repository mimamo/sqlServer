USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Sum_InvtId]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_Sum_InvtId    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.ItemSite_Sum_InvtId    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemSite_Sum_InvtId] @parm1 varchar ( 30) as
        Select Sum(QtyOnHand), Sum(TotCost) from ItemSite
         where ItemSite.InvtId = @parm1
GO
