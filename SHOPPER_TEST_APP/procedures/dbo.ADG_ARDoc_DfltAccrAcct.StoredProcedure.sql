USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_DfltAccrAcct]    Script Date: 12/21/2015 16:06:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_DfltAccrAcct]
as
	select	AccrRevAcct,
		AccrRevSub

	from	SOSetup
GO
