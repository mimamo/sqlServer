USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Select_Voided]    Script Date: 12/21/2015 16:07:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PRDoc_Select_Voided] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 smalldatetime
as

Select a.* from prdoc a, prdoc b
Where a.cpnyid = @parm1
	and a.acct = @parm2
	and a.sub = @parm3
	and a.DocType <> 'VC'
	and a.status = 'V'
	and a.ChkDate <= @parm4
	and a.rlsed = 1
	and a.acct = b.acct
	and a.sub = b.sub
	and a.ChkNbr = b.ChkNbr
	and b.DocType = 'VC'
	and b.status = 'V'
	and b.ChkDate > @parm4
	and b.rlsed = 1
Order by a.ChkNbr, a.ChkDate
GO
