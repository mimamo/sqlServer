USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRWrkItemSite_FromSiteID]    Script Date: 12/21/2015 14:34:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRWrkItemSite_FromSiteID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM IRWrkItemSite
	WHERE FromSiteID LIKE @parm1
	ORDER BY FromSiteID
GO
