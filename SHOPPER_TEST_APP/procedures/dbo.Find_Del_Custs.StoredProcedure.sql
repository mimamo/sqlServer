USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Find_Del_Custs]    Script Date: 12/21/2015 16:07:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[Find_Del_Custs] @parm1 smalldatetime as
Select c.custid from customer c, vt_08550CustBalSum v where

c.custid = v.custid and
v.LastActDate < @parm1 and
v.TotFutureBal = 0 and
v.TotCurrBal = 0
GO
