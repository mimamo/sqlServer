USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SOSetup]    Script Date: 12/21/2015 13:56:50 ******/
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
