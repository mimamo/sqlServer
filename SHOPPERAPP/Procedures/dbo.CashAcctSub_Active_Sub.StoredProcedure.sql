USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CashAcctSub_Active_Sub]    Script Date: 12/21/2015 16:13:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CashAcctSub_Active_Sub]
@Parm1 VARCHAR(10),
@Parm2 VARCHAR(10),
@Parm3 VARCHAR(24)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

SELECT *
FROM CashAcctSub_Active
WHERE CpnyID LIKE @Parm1 AND
      Active = 1 AND
      BankAcct LIKE @Parm2 AND
      BankSub LIKE @Parm3

ORDER BY CpnyID, BankAcct, BankSub
GO
