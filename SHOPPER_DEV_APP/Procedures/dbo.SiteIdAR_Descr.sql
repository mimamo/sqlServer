USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SiteIdAR_Descr]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SiteIdAR_Descr] @parm1 varchar ( 10) as
    Select name from Site where SiteID = @parm1 order by SiteID
GO
