USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CuryAcct_Cash]    Script Date: 12/21/2015 15:42:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[CuryAcct_Cash]
@Parm1 VARCHAR(10),
@Parm2 VARCHAR(10),
@Parm3 VARCHAR(24),
@Parm4 VARCHAR(10),
@Parm5 VARCHAR(4),
@Parm6 VARCHAR(4)
AS
SELECT * FROM CuryAcct
         WHERE CpnyID = @Parm1
               AND Acct   = @Parm2
               AND Sub    = @Parm3
               AND LedgerID = @Parm4
               AND FiscYr = @Parm5
               AND CuryID = @Parm6
GO
