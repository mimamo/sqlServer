USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[KeepAPCheckDoc]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.KeepAPCheckDoc    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[KeepAPCheckDoc] As
Select * From APDoc Where
BatNbr = '' and
Status = 'T'
and Acct <> ''
and Sub <> ''
and RefNbr <> ''
and DocType Not In ('MC', 'SC') Order By VendId, RefNbr
GO
