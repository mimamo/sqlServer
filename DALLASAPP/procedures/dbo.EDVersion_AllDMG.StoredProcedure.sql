USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDVersion_AllDMG]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDVersion_All    Script Date: 5/28/99 1:17:46 PM ******/
CREATE PROCEDURE [dbo].[EDVersion_AllDMG]
 @parm1 varchar( 3 )
AS
 SELECT *
 FROM EDVersion
 WHERE VersionNbr LIKE @parm1
 ORDER BY VersionNbr
GO
