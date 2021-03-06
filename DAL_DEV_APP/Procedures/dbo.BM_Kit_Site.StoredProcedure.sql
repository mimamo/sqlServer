USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM_Kit_Site]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM_Kit_Site] @parm1 varchar (30), @parm2 varchar (10) as
	Select * from Kit, Site Where
		Kit.KitId = @Parm1 and
		Kit.Siteid like @Parm2 and
		Kit.Status = 'A' and
		Kit.Siteid = Site.Siteid
	Order by Kit.Kitid, Kit.Siteid
GO
