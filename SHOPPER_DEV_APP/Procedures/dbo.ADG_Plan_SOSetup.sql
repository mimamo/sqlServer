USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SOSetup]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SOSetup]
as
	select	POAvailAtETA,
--		TransferAvailAtETA,
		S4Future09,		-- TransferAvailAtETA
		WOAvailAtETA

	from	SOSetup (nolock)
GO
