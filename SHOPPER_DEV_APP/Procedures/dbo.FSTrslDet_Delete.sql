USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FSTrslDet_Delete]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FSTrslDet_Delete    Script Date: 4/7/98 12:45:04 PM ******/
Create Procedure [dbo].[FSTrslDet_Delete] @parm1 varchar ( 10) as
     Delete fstrsldet from FSTrslDet
     where FSTrslDet.RefNbr = @parm1
GO
