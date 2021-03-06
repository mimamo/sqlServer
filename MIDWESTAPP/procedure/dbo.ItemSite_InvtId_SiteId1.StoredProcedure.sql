USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_InvtId_SiteId1]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ItemSite_InvtId_SiteId1] @parm1 varchar ( 30), @parm2 varchar ( 10) as
        Select ItemSite.*, Site.*
			from ItemSite
				left outer join Site
					on ItemSite.SiteId = Site.SiteId
			where ItemSite.InvtId = @parm1 and
                ItemSite.SiteId like @parm2
            order by ItemSite.InvtId, ItemSite.SiteId
GO
