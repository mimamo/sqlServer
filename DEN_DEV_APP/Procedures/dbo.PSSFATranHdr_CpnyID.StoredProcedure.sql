USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFATranHdr_CpnyID]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFATranHdr_CpnyID] @Parm1 VARCHAR(10), @Parm2 VARCHAR(10) AS
  SELECT * FROM PSSFATranHdr WHERE isnumeric(batnbr) = 1 AND len(batnbr) = 10 AND CpnyId = @parm1 AND BatNbr LIKE @parm2 ORDER BY BatNbr
GO
