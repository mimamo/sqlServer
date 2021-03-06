USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[CA_Find_PRDoc_Date]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[CA_Find_PRDoc_Date] @CpnyID varchar ( 10), @Acct varchar ( 10), @Sub varchar ( 24),
	@ChkNbr varchar ( 10), @ChkDate smalldatetime as
Select * from PRdoc
Where cpnyid = @CpnyID
and Acct = @Acct
and Sub = @Sub
and ChkNbr = @ChkNbr
and ChkDate = @ChkDate
and rlsed = 1
and status = 'O'
GO
