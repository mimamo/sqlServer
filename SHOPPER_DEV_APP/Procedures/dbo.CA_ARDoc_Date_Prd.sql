USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CA_ARDoc_Date_Prd]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[CA_ARDoc_Date_Prd] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (24), @parm4 smalldatetime, @parm5 varchar (6) as
Select * from batch b join ardoc a on b.batnbr = a.batnbr
Where b.cpnyid = @parm1
and b.bankacct = @parm2
and b.banksub = @parm3
and a.PerPost = @parm5
and a.rlsed = 1
and b.module = 'AR'
and b.dateent = @parm4
and b.Status <> 'V'
and b.Battype not in ('C', 'R')
and a.DocType IN ('PA', 'PP', 'CS', 'NS')
order by a.batnbr
option (fast 100)
GO
