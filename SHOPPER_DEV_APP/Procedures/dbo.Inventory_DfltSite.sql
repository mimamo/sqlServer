USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_DfltSite]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Inventory_DfltSite    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Inventory_DfltSite    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Inventory_DfltSite] @parm1 varchar ( 10) as
    Select * from Inventory where DfltSite = @parm1 order by InvtId
GO
