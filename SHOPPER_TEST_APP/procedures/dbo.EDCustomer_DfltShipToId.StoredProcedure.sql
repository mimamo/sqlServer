USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomer_DfltShipToId]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustomer_DfltShipToId] @Parm1 varchar(15) As Select DfltShipToId From Customer
Where CustId = @Parm1
GO
