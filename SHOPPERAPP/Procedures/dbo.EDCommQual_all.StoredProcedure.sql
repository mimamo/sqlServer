USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCommQual_all]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDCommQual_all]
 @parm1 varchar( 2 )
AS
 SELECT *
 FROM EDCommQual
 WHERE CommID LIKE @parm1
 ORDER BY CommID
GO
