USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[FindLedgerID]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FindLedgerID    Script Date: 4/7/98 12:38:58 PM ******/
Create Procedure [dbo].[FindLedgerID]  As
Select ledgerid from glsetup
GO
