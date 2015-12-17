USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SelectTempAPCheckDoc]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SelectTempAPCheckDoc    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[SelectTempAPCheckDoc] @parm1 varchar ( 15) As
Select * From APDoc
Where APDoc.VendId = @parm1 and
APDoc.Status = 'T' and
APDoc.Acct = '' and
APDoc.Sub = '' and
APDoc.RefNbr = ''
Order By APDoc.VendId, APDoc.InvcNbr
GO
