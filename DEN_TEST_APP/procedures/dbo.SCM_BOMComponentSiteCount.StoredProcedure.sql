USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_BOMComponentSiteCount]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_BOMComponentSiteCount]
	@parm1 varchar( 30 ), @parm2 varchar ( 10 )
AS
	SELECT Count(Distinct SiteID) FROM Component WHERE
		KitID = @parm1 and
		KitSiteID = @parm2 and
		KitStatus = 'A'
GO
