USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_BOMComponentSiteCount]    Script Date: 12/16/2015 15:55:32 ******/
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
