USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_Single]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSite_Single] @parm1 varchar(10), @parm2 varchar(3)  As Select * from EDSite where SiteID = @parm1 and Trans = @parm2
GO
