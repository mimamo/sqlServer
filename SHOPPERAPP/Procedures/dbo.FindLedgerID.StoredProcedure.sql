USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[FindLedgerID]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FindLedgerID    Script Date: 4/7/98 12:38:58 PM ******/
Create Procedure [dbo].[FindLedgerID]  As
Select ledgerid from glsetup
GO
