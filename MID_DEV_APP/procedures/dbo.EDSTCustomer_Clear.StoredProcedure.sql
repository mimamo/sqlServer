USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSTCustomer_Clear]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSTCustomer_Clear] @CustId varchar(15) As
Delete From EDSTCustomer Where CustId = @CustId
GO
