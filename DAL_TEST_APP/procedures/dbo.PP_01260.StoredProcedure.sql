USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PP_01260]    Script Date: 12/21/2015 13:57:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PP_01260] @Company Varchar ( 10)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	Begin Tran
	Delete from VW_AcctXRef where cpnyid = @Company
	Insert into VW_AcctXRef (Acct, AcctType, Active, CpnyId , Descr, User1, User2, User3, User4)
        	 Select Acct, AcctType, Active, @company, Descr, User1, User2, User3, User4 from Account
	Commit
GO
