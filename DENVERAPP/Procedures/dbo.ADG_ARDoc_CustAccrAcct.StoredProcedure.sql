USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_CustAccrAcct]    Script Date: 12/21/2015 15:42:39 ******/
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
