USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SiteIdAR_Descr]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SiteIdAR_Descr] @parm1 varchar ( 10) as
    Select name from Site where SiteID = @parm1 order by SiteID
GO
