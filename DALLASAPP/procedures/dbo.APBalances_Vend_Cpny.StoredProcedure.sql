USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[APBalances_Vend_Cpny]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APBalances_Vend_Cpny    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APBalances_Vend_Cpny] @parm1 varchar ( 15), @parm2 varchar ( 10) As
Select * from AP_Balances
where VendID LIKE @parm1
and CpnyId LIKE @parm2
GO
