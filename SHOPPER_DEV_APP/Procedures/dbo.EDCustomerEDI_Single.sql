USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomerEDI_Single]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustomerEDI_Single] @CustId varchar(15) As
Select * From CustomerEDI Where
CustId = @CustId
GO
