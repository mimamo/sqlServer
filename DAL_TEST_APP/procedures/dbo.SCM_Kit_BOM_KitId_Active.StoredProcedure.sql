USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Kit_BOM_KitId_Active]    Script Date: 12/21/2015 13:57:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SCM_Kit_BOM_KitId_Active]
	@Parm1 varchar (30), @Parm2 varchar (10)
AS
	SELECT Kit.* FROM Kit,Site where
		Kit.KitID = @Parm1 AND
		Kit.Status = 'A' AND
		Kit.KitType = 'B' AND
		Kit.ExpKitDet = 1 AND
		Kit.SiteID LIKE @Parm2 AND
		Site.SiteID = Kit.SiteID
	ORDER BY Kit.SiteID
GO
