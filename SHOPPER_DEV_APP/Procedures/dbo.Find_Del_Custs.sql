USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Find_Del_Custs]    Script Date: 12/16/2015 15:55:22 ******/
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
