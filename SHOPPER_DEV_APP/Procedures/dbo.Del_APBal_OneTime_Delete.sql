USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Del_APBal_OneTime_Delete]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Del_APBal_OneTime_Delete    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Del_APBal_OneTime_Delete] @parm1 varchar(15) as
Select * from AP_Balances where
AP_Balances.Vendid = @parm1 and
AP_Balances.FutureBal = 0 and
AP_Balances.CurrBal = 0
GO
