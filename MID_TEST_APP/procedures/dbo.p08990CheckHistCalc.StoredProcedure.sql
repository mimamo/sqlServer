USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckHistCalc]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[p08990CheckHistCalc] as

Insert into WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)

select v.custid, v.cpnyid, 30, v.CalcCurBal, v.SumNewBals, 0, ''

from vi_08990CompHistToCalc v, currncy c (nolock), glsetup g (nolock)

where Round(v.CalcCurBal, c.decpl) <> Round(v.SumNewBals, c.decpl)
and g.basecuryid = c.curyid
GO
