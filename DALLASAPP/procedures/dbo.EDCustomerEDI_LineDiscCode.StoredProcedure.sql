USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomerEDI_LineDiscCode]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustomerEDI_LineDiscCode] @CustId varchar(15) As
	Select C.S4Future12, E.Description
		From CustomerEDI C
			Left Outer Join Eddataelement E
				ON C.S4future12 = E.Code
		Where CustId = @Custid
GO
