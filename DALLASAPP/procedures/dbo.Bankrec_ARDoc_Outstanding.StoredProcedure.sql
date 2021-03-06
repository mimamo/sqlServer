USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Bankrec_ARDoc_Outstanding]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Bankrec_ARDoc_Outstanding] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime  as
Select * from batch b join ardoc a on b.batnbr = a.batnbr
where a.cpnyid = @parm1
and a.bankacct = @parm2
and a.banksub = @parm3
and a.rlsed = 1
and b.battype <> 'C'
and b.module = 'AR'
and (b.Cleared = 0 and a.docdate <= @parm4)
GO
