USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankRec_LastStmt]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BankRec_LastStmt    Script Date: 4/7/98 12:49:19 PM ******/
Create Proc [dbo].[BankRec_LastStmt] @parm1 smalldatetime as
Select * from BankRec
where ReconDate > @parm1
Order by recondate desc
GO
