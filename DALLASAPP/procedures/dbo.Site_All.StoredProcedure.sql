USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Site_All]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Site_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Site_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[Site_All] @parm1 varchar ( 10) as
    Select * from Site where SiteId like @parm1 order by SiteId
GO
