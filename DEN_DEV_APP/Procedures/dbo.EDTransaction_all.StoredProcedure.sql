USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTransaction_all]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDTransaction_all]
 @parm1 varchar( 3 ),
 @parm2 varchar( 1 )
AS
 SELECT *
 FROM EDTransaction
 WHERE Trans LIKE @parm1
    AND Direction LIKE @parm2
 ORDER BY Trans,
    Direction
GO
