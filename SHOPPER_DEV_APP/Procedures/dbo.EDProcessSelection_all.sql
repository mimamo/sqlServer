USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDProcessSelection_all]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDProcessSelection_all]
 @parm1 varchar( 20 )
AS
 SELECT *
 FROM EDProcessSelection
 WHERE EXEName LIKE @parm1
 ORDER BY EXEName
GO
