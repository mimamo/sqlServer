USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CU_GLSetupSelected]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CU_GLSetupSelected]
	@ValidateAcctSub	smallint OUTPUT
as
	select	@ValidateAcctSub = ValidateAcctSub
	from	GLSetup (NOLOCK)

	if @@ROWCOUNT = 0
		return 0	--Failure
	else
		return 1	--Success
GO
