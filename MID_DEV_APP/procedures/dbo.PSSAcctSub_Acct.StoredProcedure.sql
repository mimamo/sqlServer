USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAcctSub_Acct]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAcctSub_Acct] @parm1 VARCHAR(10), @parm2 VARCHAR(24), @parm3 VARCHAR(10) AS
  SELECT * FROM vw_AcctSub WHERE CpnyID LIKE @parm1 AND Active = 1 AND Sub LIKE @parm2 AND Acct LIKE @parm3 ORDER BY Acct, Sub
GO
