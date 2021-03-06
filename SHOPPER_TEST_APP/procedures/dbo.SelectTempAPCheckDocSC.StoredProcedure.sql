USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SelectTempAPCheckDocSC]    Script Date: 12/21/2015 16:07:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SelectTempAPCheckDocSC    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[SelectTempAPCheckDocSC] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10) As
Select * from APDoc
where APDoc.VendId = @parm1 AND APDoc.Status = 'T' and
APDoc.Acct = @parm2 and APDoc.Sub = @parm3 and
APDoc.RefNbr = @parm4
Order By APDoc.VendId, APDoc.InvcNbr
GO
