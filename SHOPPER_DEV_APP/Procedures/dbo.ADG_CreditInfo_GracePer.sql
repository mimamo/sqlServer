USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditInfo_GracePer]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditInfo_GracePer]
	@CustID	varchar(15)
as
	select	GracePer
	from	CustomerEDI (nolock)
	where	CustID = @CustID
GO
