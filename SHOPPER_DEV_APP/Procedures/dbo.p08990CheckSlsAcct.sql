USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckSlsAcct]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[p08990CheckSlsAcct] as

Insert into WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)

select c.custid, '', 3, 0, 0, 0, c.slsacct

from customer c LEFT OUTER JOIN account a on c.slsacct = a.acct

where LTRIM(RTRIM(a.acct)) IS NULL
GO
