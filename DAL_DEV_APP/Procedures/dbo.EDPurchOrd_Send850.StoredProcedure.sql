USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_Send850]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDPurchOrd_Send850] As
Select A.PONbr From PurchOrd A Inner Join EDPurchOrd B On A.PONbr = B.PONbr Where Exists (Select *
From EDVOutbound Where Trans = '850' And VendId = A.VendId) And B.LastEDIDate = '01/01/1900' And
A.Status = 'O'
GO
