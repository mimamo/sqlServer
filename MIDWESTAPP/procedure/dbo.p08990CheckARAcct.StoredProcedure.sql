USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckARAcct]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[p08990CheckARAcct] as

Insert into WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)

select c.custid, '', 2, 0, 0, 0, c.aracct

from customer c LEFT OUTER JOIN account a on c.aracct = a.acct

where LTRIM(RTRIM(a.acct)) IS NULL
GO
