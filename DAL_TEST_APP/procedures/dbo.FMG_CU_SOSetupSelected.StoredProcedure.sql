USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CU_SOSetupSelected]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CU_SOSetupSelected]
	@ConsolInv	smallint OUTPUT
as
	select	@ConsolInv = ConsolInv
	from	SOSetup (NOLOCK)

	if @@ROWCOUNT = 0
		return 0	--Failure
	else
		return 1	--Success
GO
