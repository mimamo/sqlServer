USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_All]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_All    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.ItemSite_All    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[ItemSite_All] @parm1 varchar ( 30) As
    Select * from itemsite
            Where Invtid = @parm1
            Order by SiteId
GO
