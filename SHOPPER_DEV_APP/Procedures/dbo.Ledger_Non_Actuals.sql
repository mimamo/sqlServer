USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ledger_Non_Actuals]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Ledger_Non_Actuals    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc [dbo].[Ledger_Non_Actuals] @parm1 varchar ( 10) as
       Select * from Ledger
           where LedgerID   like @parm1
           and (balancetype = "S" or balancetype = "B")
             order by LedgerID
GO
