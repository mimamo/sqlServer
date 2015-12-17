USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POBudHist_all]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POBudHist_all    Script Date: 12/17/97 10:48:25 AM ******/
Create Procedure [dbo].[POBudHist_all] @parm1 Varchar(10), @parm2 Varchar(24), @parm3 Varchar(10), @parm4 Varchar(4) as
Select * from POBudhist where
acct = @parm1 and
sub = @parm2 and
Ledgerid = @parm3 and
FiscYr = @parm4
Order By acct, sub, Ledgerid, fiscyr
GO
