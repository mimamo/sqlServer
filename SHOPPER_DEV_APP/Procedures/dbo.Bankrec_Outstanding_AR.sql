USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Bankrec_Outstanding_AR]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[Bankrec_Outstanding_AR] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime, @parm5 smalldatetime  as
select * from batch b join ardoc a on b.batnbr = a.batnbr
where a.cpnyid = @parm1
and a.bankacct = @parm2
and a.banksub = @parm3
and a.docdate  <= @parm4
and a.rlsed = 1
and (b.Cleared = 0 or (b.cleared = 1 and b.DateClr > @parm4 and b.DateClr <= @parm5))
and b.module = 'AR'
order by a.batnbr, a.refnbr, a.docdate
GO
