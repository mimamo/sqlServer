USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smUnbillTax_Detail]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[smUnbillTax_Detail]
@taxID varchar (10),
@callID varchar (10) as

SELECT Sum(TaxAmt00), Sum(TxblAmt00) 
FROM smServDetail
WHERE TaxID00 = @taxID
	AND ServiceCallID =  @callID
	AND BillFlag = '0'
	AND TaxExempt = 'N'
GO
