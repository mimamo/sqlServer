USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_GetInvoiceTrans]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDOutbound_GetInvoiceTrans] @CustId varchar(15) As
Select Trans From EDOutbound Where CustId = @CustId And Trans In ('810','880')
GO
