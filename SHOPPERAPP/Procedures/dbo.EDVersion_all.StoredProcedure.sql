USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDVersion_all]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDVersion_all]
 @parm1 varchar( 3 )
AS
 SELECT *
 FROM EDVersion
 WHERE VersionNbr LIKE @parm1
 ORDER BY VersionNbr
GO
