USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_TrslDet_RefNbr]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_TrslDet_RefNbr    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[Delete_TrslDet_RefNbr] @parm1 varchar ( 10) AS
     Delete fstrsldet from FSTrslDet
          Where RefNbr = @parm1
GO
