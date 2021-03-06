USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990ChkFutBal]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[p08990ChkFutBal] as

Insert into WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)

select v.custid, v.cpnyid, 20, v.OldFutureBal, v.NewFutureBal, 0, ''

from vi_08990CompCustBal v, currncy c (nolock), glsetup g (nolock)
where round(v.NewFutureBal, c.decpl) <> round(v.OldFutureBal, c.decpl)
and c.curyid = g.basecuryid
GO
