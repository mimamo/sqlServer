USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCurrency_all]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDCurrency_all]
 @parm1 varchar( 10 ),
 @parm2 varchar( 10 )
AS
 SELECT *
 FROM EDCurrency
 WHERE CuryId LIKE @parm1
    AND EDCuryId LIKE @parm2
 ORDER BY CuryId,
    EDCuryId
GO
