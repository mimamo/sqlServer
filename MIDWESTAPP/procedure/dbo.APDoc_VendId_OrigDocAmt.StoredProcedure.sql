USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_VendId_OrigDocAmt]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_VendId_OrigDocAmt    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APDoc_VendId_OrigDocAmt] @parm1 varchar ( 15), @parm2 float, @parm3 varchar ( 10) as
Select * from APDoc where VendId = @parm1
and Status <> "V"
and DocClass = 'N'
and CuryOrigDocAmt = @parm2
and RefNbr <> @parm3
GO
