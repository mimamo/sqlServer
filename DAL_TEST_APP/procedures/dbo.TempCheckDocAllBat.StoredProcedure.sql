USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TempCheckDocAllBat]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TempCheckDocAllBat    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[TempCheckDocAllBat] As
Select * From APDoc Where
BatNbr = '' and
RefNbr = '' and
DocType = 'CK' and
Status = 'T'
Order By APDoc.VendId, APDoc.InvcNbr
GO
