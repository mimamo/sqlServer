USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDRelease_all]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDRelease_all]
 @parm1 varchar( 3 )
AS
 SELECT *
 FROM EDRelease
 WHERE ReleaseNbr LIKE @parm1
 ORDER BY ReleaseNbr
GO
