USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAPTran_BatNbr]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteAPTran_BatNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteAPTran_BatNbr] @parm1 varchar ( 10) As
Delete aptran from APTran Where BatNbr = @parm1
GO
