USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DelTempChkTranEa]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DelTempChkTranEa    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DelTempChkTranEa] @parm1 varchar ( 15) As
Delete aptran from APTran Where
APTran.ExtRefNbr = @parm1 and
APTran.BatNbr = '' and
APTran.AcctDist = 0 and
APTran.Rlsed = 0 and
APTran.DrCr = 'S'
GO
