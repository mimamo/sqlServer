USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAPTran_BatNbr]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteAPTran_BatNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteAPTran_BatNbr] @parm1 varchar ( 10) As
Delete aptran from APTran Where BatNbr = @parm1
GO
