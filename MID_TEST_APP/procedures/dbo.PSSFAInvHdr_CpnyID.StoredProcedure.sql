USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAInvHdr_CpnyID]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAInvHdr_CpnyID] @Parm1 VARCHAR(10), @Parm2 VARCHAR(10) AS
  SELECT * FROM PSSFAInvHdr WHERE isnumeric(batnbr) = 1 AND len(batnbr) = 10 AND CpnyId = @parm1 AND BatNbr LIKE @parm2 ORDER BY BatNbr
GO
