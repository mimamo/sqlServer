USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_APDoc_]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_APDoc_Acct_Sub_    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_APDoc_] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3beg smallint, @parm3end smallint as
Select * from APTran, APDoc where
Aptran.Batnbr = @parm1
and APTran.RefNbr = @parm2
and APTran.LineNbr between @parm3beg and @parm3end
and APTran.UnitDesc = APDoc.RefNbr
and APTran.CostType = APDoc.DocType ---+ '      '
and APTran.DRCR = "S"
order by APTran.Acct, APTran.Sub, APTran.RefNbr, APTran.LineNbr
GO
