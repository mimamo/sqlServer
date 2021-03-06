USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CU_CompanySelected]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CU_CompanySelected]
	@CpnyID		varchar(10),
	@CpnyCOA	varchar(10) OUTPUT,
	@CpnySub	varchar(10) OUTPUT

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	select	@CpnyCOA = ltrim(rtrim(CpnyCOA)),
		@CpnySub = ltrim(rtrim(CpnySub))
	from	VS_COMPANY (NOLOCK)
	where	CpnyID = @CpnyID

	if @@ROWCOUNT = 0
		return 0	--Failure
	else
		return 1	--Success
GO
