USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRWrkItemSite_all]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRWrkItemSite_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM IRWrkItemSite
	WHERE SiteID LIKE @parm1
	ORDER BY SiteID
GO
