USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Site_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Site_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Site_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[Site_All] @parm1 varchar ( 10) as
    Select * from Site where SiteId like @parm1 order by SiteId
GO
