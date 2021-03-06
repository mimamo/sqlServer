USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SelectTempAPCheckTran]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SelectTempAPCheckTran    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[SelectTempAPCheckTran] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 8), @parm4 varchar (1) As
Select * From APTran
Where APTran.VendId = @parm1
and APTran.UnitDesc = @parm2
and APTran.CostType = @parm3
and APTran.PmtMethod LIKE @parm4
and APTran.DrCr = 'S'
and RefNbr = ''
Order By Acct, Sub, RefNbr, LineNbr
GO
