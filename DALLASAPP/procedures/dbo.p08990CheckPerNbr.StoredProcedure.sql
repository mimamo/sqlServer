USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckPerNbr]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[p08990CheckPerNbr] @ARPerNbr varchar (6) as

Insert into WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)

select c.custid, '', 1, 0, 0, 0, c.pernbr

from customer c

where LTRIM(RTRIM(c.pernbr)) <> LTRIM(RTRIM(@ARPerNbr))
GO
