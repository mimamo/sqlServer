USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDocCk_View_Select]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDocCk_View_Select    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDocCk_View_Select] @parm1 varchar ( 10) as
Select RefNbr, CuryOrigDocAmt, InvcNbr, VendId, CuryDiscBal, PmtMethod from APDoc
        Where BatNbr = @parm1
        Order by VendID, InvcNbr
GO
