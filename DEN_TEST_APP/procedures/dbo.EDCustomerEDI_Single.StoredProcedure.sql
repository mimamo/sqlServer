USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomerEDI_Single]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustomerEDI_Single] @CustId varchar(15) As
Select * From CustomerEDI Where
CustId = @CustId
GO
