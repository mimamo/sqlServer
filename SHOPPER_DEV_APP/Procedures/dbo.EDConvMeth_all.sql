USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_all]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDConvMeth_all]
 @parm1 varchar( 3 ),
 @parm2 varchar( 3 ),
 @parm3 varchar( 1 )
AS
 SELECT *
 FROM EDConvMeth
 WHERE Trans LIKE @parm1
    AND ConvCode LIKE @parm2
    AND Direction LIKE @parm3
 ORDER BY Trans,
    ConvCode,
    Direction
GO
