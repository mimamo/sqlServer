USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TempCheckDocAll]    Script Date: 12/21/2015 14:18:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TempCheckDocAll    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[TempCheckDocAll] As
Select * From APDoc Where
RefNbr = '' and
DocType = 'CK' and
Status = 'T'
Order By APDoc.VendId, APDoc.InvcNbr
GO
