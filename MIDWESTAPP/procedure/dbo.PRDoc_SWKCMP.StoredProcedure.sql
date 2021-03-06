USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_SWKCMP]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PRDoc_SWKCMP] @parm1 smalldatetime , @parm2 smalldatetime   as
SELECT PRDoc.chkdate,
PRDoc.BatNbr,
PRDoc.EmpId,
PRDoc.PayPerEndDate,
PRDoc.Acct,
PRDoc.Sub,
PRDoc.Chknbr,
PRDoc.Doctype,
PRTran.*,
EarnType.*
FROM
PRDoc, PRTran, EarnType
Where
PRDoc.chkdate >= @parm1 AND
PRDoc.chkdate <= @parm2 AND
PRDoc.BatNbr = PRTran.BatNbr AND
PRDoc.EmpId = PRTran.EmpId AND
PRTran.User1 <> ' ' AND
PRTran.User4 = 0 AND
PRTran.EarnDedId = EarnType.Id AND
(EarnType.EtType = 'B' or EarnType.EtType = 'R')
Order By
PRDoc.PayPerEndDate,
PRDoc.EmpId
GO
