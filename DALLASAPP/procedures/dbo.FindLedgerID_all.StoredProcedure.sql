USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[FindLedgerID_all]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FindLedgerID_all    Script Date: 4/7/98 12:38:58 PM ******/
Create Procedure [dbo].[FindLedgerID_all] @parm1 varchar ( 10)  As
Select LedgerID from Ledger where ledgerid like @parm1
Order by LedgerID
GO
