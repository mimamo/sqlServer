USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAcctHist_all]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAcctHist_all    Script Date: 12/17/97 10:48:22 AM ******/
Create Procedure [dbo].[POAcctHist_all] @parm1 Varchar(10), @parm2 Varchar(24), @parm3 Varchar(10), @parm4 Varchar(4) as
Select * from accthist where
acct = @parm1 and
sub = @parm2 and
LedgerID = @parm3 and
FiscYr = @parm4
Order By acct, sub, ledgerID, fiscyr
GO
