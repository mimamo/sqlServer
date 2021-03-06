USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_InvtId_Cpny]    Script Date: 12/21/2015 16:01:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ItemSite_InvtId_Cpny] @parm1 varchar ( 30), @parm2 varchar (10) as
        Select ItemSite.* from ItemSite
        JOIN Site on ItemSite.SiteID = Site.SiteId
        where InvtId = @parm1
        and Site.CpnyID = @parm2 
        order by ItemSite.InvtId, ItemSite.SiteId
GO
