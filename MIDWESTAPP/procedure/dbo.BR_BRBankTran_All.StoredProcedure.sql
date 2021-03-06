USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRBankTran_All]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BR_BRBankTran_All]
@parm1 As varchar(10),
@parm2 As varchar(6),
@parm3 As smallint,
@parm4 As smallint
AS
SELECT *
FROM BRBankTran
WHERE AcctId = @parm1
AND CurrPerNbr = @parm2
AND LineNbr BETWEEN @parm3 AND @parm4
ORDER BY AcctId, CurrPerNbr, LineNbr
GO
