USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ledger_All]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Ledger_All    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc [dbo].[Ledger_All] @parm1 varchar ( 10) as
       Select * from Ledger
           where LedgerID   like @parm1
             order by LedgerID
GO
