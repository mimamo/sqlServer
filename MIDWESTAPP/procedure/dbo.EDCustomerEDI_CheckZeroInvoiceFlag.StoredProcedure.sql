USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomerEDI_CheckZeroInvoiceFlag]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustomerEDI_CheckZeroInvoiceFlag] @CustId varchar(15) As
Select S4Future10 From CustomerEDI Where CustId = @CustId
GO
