USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_Direction]    Script Date: 12/21/2015 13:57:00 ******/
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
