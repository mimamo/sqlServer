USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteTempCheckTran]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteTempCheckTran    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteTempCheckTran] As
Delete from APTran Where
BatNbr = '' and
Acct = '' and
Sub = '' and
DrCr = 'S'
GO
