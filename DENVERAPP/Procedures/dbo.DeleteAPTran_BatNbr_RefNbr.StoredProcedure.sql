USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAPTran_BatNbr_RefNbr]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteAPTran_BatNbr_RefNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteAPTran_BatNbr_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) As
Delete aptran from APTran Where BatNbr = @parm1
and RefNbr = @parm2
GO
