USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRCAPDoc]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteRCAPDoc    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteRCAPDoc] @parm1 varchar ( 10), @parm2 varchar ( 2) As

Delete From APDoc Where
APDoc.RefNbr = @parm1 and
APDoc.DocType = @parm2
IF @@ERROR <> 0 GOTO ABORT

Delete From APTran Where
APTran.RefNbr = @parm1 and
APTran.TranType = @parm2
IF @@ERROR <> 0 GOTO ABORT

ABORT:
GO
