USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomer_DfltShipToId]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustomer_DfltShipToId] @Parm1 varchar(15) As Select DfltShipToId From Customer
Where CustId = @Parm1
GO
