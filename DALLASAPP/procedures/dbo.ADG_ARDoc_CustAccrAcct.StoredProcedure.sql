USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_CustAccrAcct]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_CustAccrAcct]
	@CustID	varchar(15)
as
	select	AccrRevAcct,
		AccrRevSub
	from	Customer
	where	CustID = @CustID
GO
