USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOTran_BatNbr]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOTran_BatNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOTran_BatNbr] @parm1 varchar ( 10) As
   Delete potran from POTran Where BatNbr = @parm1
GO
