USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[BankRec_LastStmt]    Script Date: 12/21/2015 13:44:46 ******/
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
