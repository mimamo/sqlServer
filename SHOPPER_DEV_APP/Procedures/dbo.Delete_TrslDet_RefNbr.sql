USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_TrslDet_RefNbr]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_TrslDet_RefNbr    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[Delete_TrslDet_RefNbr] @parm1 varchar ( 10) AS
     Delete fstrsldet from FSTrslDet
          Where RefNbr = @parm1
GO
