USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[UpdatePRCheckTranTotals]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[UpdatePRCheckTranTotals]
@ASIDlookup int
as

Set NoCount On
Declare @CheckEmpID	Char(10),
        @CheckSeqNbr Char(2),
        @ASIDNbr int

Declare csr_wrkCheck Cursor Static
For
Select Distinct EmpID, ChkSeq, ASID
From PRCheckTran
Where ASID = @ASIDlookup




Open csr_wrkCheck
Fetch Next From csr_wrkCheck InTo @CheckEmpID, @CheckSeqNbr, @ASIDNbr

While @@fetch_status = 0
Begin
	Update PRCheckTran
	Set CurrEarn = (Select Top 1 CurrEarn   
							From PRCheckTran
							Where Col1Type = 'E'
								And EmpID = @CheckEmpID
								And ChkSeq = @CheckSeqNbr
								And ASID = @ASIDNbr),
		CurrNet = (Select Top 1 CurrNet   
							From PRCheckTran
							Where Col1Type = 'E'
								And EmpID = @CheckEmpID
								And ChkSeq = @CheckSeqNbr
								And ASID = @ASIDNbr),
		S4Future01 = '1'
	Where Col1Type = 'D'
		And rtrim(Col1Descr) = ''
		And EmpID = @CheckEmpID
		And ChkSeq = @CheckSeqNbr
		And ASID = @ASIDNbr

	Fetch Next From csr_wrkCheck InTo @CheckEmpID, @CheckSeqNbr, @ASIDNbr
End
Close csr_wrkCheck
Deallocate csr_wrkCheck
GO
