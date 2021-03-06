USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Ledger_Non_Actuals]    Script Date: 12/21/2015 16:13:16 ******/
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
