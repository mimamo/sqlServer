USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FindLedgerID]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FindLedgerID    Script Date: 4/7/98 12:38:58 PM ******/
Create Procedure [dbo].[FindLedgerID]  As
Select ledgerid from glsetup
GO
