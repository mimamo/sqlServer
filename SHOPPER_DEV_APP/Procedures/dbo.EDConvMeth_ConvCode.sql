USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_ConvCode]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDConvMeth_ConvCode]
 @parm1 varchar( 3 )
AS
 SELECT *
 FROM EDConvMeth
 WHERE ConvCode LIKE @parm1
 ORDER BY ConvCode
GO
