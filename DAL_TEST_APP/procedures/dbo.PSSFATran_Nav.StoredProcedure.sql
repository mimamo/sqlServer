USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFATran_Nav]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFATran_Nav] @parm1 VARCHAR(10), @parm2min SMALLINT, @parm2max SMALLINT AS
  SELECT * FROM PSSFATran WHERE BatNbr = @parm1 AND lineid BETWEEN @parm2min AND @parm2max
GO
