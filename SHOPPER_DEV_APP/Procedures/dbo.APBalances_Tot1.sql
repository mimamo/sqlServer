USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APBalances_Tot1]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APBalances_Tot1    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APBalances_Tot1] @parm1 varchar ( 15) As
Select MAX(LastChkDate), MAX(LastVODate), SUM(CurrBal), SUM(FutureBal)
From AP_Balances Where AP_Balances.VendID = @parm1
GO
