USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TempCheckDocAllBat]    Script Date: 12/16/2015 15:55:35 ******/
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
