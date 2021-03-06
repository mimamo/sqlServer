USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CA_AR_Batch_BatNbr]    Script Date: 12/21/2015 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CA_AR_Batch_BatNbr    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[CA_AR_Batch_BatNbr] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (24), @parm4 smalldatetime, @parm5 smalldatetime as
Select distinct b.* from batch b INNER JOIN ardoc d on b.batnbr = d.batnbr
Where b.CpnyID = @parm1
and b.BankAcct = @parm2
and b.BankSub = @parm3
and b.Module = 'AR'
and b.Status <> 'V'
and b.Rlsed = 1
and b.Battype not in ('C', 'R')
and d.DocType IN ('PA', 'PP', 'CS', 'NS')
and (b.dateent <= @parm4 and b.dateent >= @parm5)
Order by b.BatNbr
GO
