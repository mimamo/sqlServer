USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smUnbillTax_Detail]    Script Date: 12/16/2015 15:55:35 ******/
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
