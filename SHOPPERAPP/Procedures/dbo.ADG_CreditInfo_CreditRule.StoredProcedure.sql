USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditInfo_CreditRule]    Script Date: 12/21/2015 16:12:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditInfo_CreditRule]
	@CustID	varchar(15)
as
	select	CreditRule
	from	CustomerEDI (nolock)
	where	CustID = @CustID
GO
