USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteTempCheckDoc]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteTempCheckDoc    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteTempCheckDoc] As
Delete From APDoc Where
BatNbr = '' and
RefNbr = '' and
DocType = 'CK' and
Status = 'T'
GO
