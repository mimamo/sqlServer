USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSODiscCode_all]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSODiscCode_all]
 @parm1 varchar( 10 ),
 @parm2 varchar( 1 )
AS
 SELECT *
 FROM EDSODiscCode
 WHERE CpnyId LIKE @parm1
    AND DiscountID LIKE @parm2
 ORDER BY CpnyId,
    DiscountID
GO
