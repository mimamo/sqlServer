USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_GetInvoiceTrans]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDOutbound_GetInvoiceTrans] @CustId varchar(15) As
Select Trans From EDOutbound Where CustId = @CustId And Trans In ('810','880')
GO
