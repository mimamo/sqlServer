USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_Direction]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDConvMeth_Direction]
 @parm1 varchar( 1 )
AS
 SELECT *
 FROM EDConvMeth
 WHERE Direction LIKE @parm1
 ORDER BY Direction
GO
