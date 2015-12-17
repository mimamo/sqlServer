USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDRelease_AllDMG]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDRelease_All    Script Date: 5/28/99 1:17:43 PM ******/
CREATE PROCEDURE [dbo].[EDRelease_AllDMG]
 @parm1 varchar( 3 )
AS
 SELECT *
 FROM EDRelease
 WHERE ReleaseNbr LIKE @parm1
 ORDER BY ReleaseNbr
GO
