USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_all]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSite_all]
 @parm1 varchar( 10 ),
 @parm2 varchar( 3 )
AS
 SELECT *
 FROM EDSite
 WHERE SiteID LIKE @parm1
    AND Trans LIKE @parm2
 ORDER BY SiteID,
    Trans
GO
