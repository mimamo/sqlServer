USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVersion_all]    Script Date: 12/16/2015 15:55:22 ******/
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
