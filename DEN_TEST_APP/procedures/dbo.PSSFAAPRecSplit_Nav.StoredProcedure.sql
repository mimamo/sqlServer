USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAPRecSplit_Nav]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAPRecSplit_Nav] @parm1 SMALLINT, @parm2 SMALLINT, @parm3min SMALLINT, @parm3max SMALLINT AS
  SELECT * FROM  PSSFAAPRecSplit WHERE AccessNbr = @parm1 AND APRecLineId = @parm2 AND linenbr between @parm3min AND @parm3max ORDER BY AccessNbr, APRecLineId
GO
