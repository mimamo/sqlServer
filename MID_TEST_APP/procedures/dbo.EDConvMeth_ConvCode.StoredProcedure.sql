USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_ConvCode]    Script Date: 12/21/2015 15:49:19 ******/
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
