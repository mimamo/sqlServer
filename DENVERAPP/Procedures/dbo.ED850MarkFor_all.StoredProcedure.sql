USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850MarkFor_all]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850MarkFor_all]
 @parm1 varchar( 10 ),
 @parm2 varchar( 10 )
AS
 SELECT *
 FROM ED850MarkFor
 WHERE Cpnyid LIKE @parm1
    AND EDIPoId LIKE @parm2
 ORDER BY Cpnyid,
    EDIPoId
GO
