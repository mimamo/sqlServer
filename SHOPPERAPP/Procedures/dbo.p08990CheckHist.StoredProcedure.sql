USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckHist]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[p08990CheckHist] as

Insert into WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)

select b.custid, b.cpnyid, 40, 0, 0, 0, ''

from ar_balances b LEFT OUTER JOIN arhist a on b.custid = a.custid and b.cpnyid = a.cpnyid

where LTRIM(RTRIM(b.cpnyid)) IS NULL
GO
