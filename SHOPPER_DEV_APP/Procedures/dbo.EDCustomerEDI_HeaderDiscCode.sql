USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomerEDI_HeaderDiscCode]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustomerEDI_HeaderDiscCode] @CustId varchar(15) As
	Select C.S4Future11, E.Description
		From CustomerEDI C
			Left Outer Join Eddataelement E
				ON C.S4future11 = E.Code
		Where CustId = @Custid
GO
