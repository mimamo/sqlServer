USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990ChkCurBal]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[p08990ChkCurBal] as

Insert into WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)

select v.custid, v.cpnyid, 10, v.OldCurrentBal, v.NewCurrentBal, 0, ''

from vi_08990CompCustBal v, currncy c (nolock), glsetup g (nolock)
where round(v.NewCurrentBal, c.decpl) <> round(v.OldCurrentBal, c.decpl)
and c.curyid = g.basecuryid
GO
