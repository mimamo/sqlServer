USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashAcctSub_Active_Acct]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CashAcctSub_Active_Acct]
@Parm1 VARCHAR(10),
@Parm2 VARCHAR(24),
@Parm3 VARCHAR(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

SELECT DISTINCT *
FROM CashAcctSub_Active
WHERE CpnyID LIKE @Parm1 AND
      Active = 1 AND
      BankSub LIKE @Parm2 AND
      BankAcct LIKE @Parm3

ORDER BY CpnyID, BankAcct, BankSub
GO
