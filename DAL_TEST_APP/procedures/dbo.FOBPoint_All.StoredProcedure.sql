USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FOBPoint_All]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FOBPoint_All] @parm1 VARCHAR(15)
AS
      SELECT * FROM FOBPoint
      WHERE FOBid LIKE @parm1
      ORDER BY FOBid
GO
