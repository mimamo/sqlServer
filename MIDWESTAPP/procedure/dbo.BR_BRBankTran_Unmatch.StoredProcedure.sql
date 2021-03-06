USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRBankTran_Unmatch]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BR_BRBankTran_Unmatch]
@parm1 As varchar(10),
@parm2 As varchar(10),
@parm3 As varchar(6),
@parm4 As smallint,
@parm5 As smallint
AS
SELECT *
FROM BRBankTran
WHERE cpnyid = @parm1 and AcctId = @parm2
AND CurrPerNbr = @parm3
AND LineNbr BETWEEN @parm4 AND @parm5
AND BookRefNbr = ''
ORDER BY AcctId, CurrPerNbr, LineNbr
GO
