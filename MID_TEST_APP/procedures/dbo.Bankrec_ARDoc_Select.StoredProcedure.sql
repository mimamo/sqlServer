USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Bankrec_ARDoc_Select]    Script Date: 12/21/2015 15:49:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[Bankrec_ARDoc_Select] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime, @parm5 smalldatetime as
Select * from batch b join ardoc a on b.batnbr = a.batnbr
Where b.cpnyid = @parm1
and b.bankacct = @parm2
and b.banksub = @parm3
and (b.dateent >= @parm4 and b.dateent <= @parm5)
and a.rlsed = 1
and b.module = 'AR'
and b.Status <> 'V'
and b.Battype not in ('C', 'R')
and a.DocType IN ('PA', 'PP', 'CS', 'NS')
order by a.batnbr, a.refnbr, b.dateent
GO
