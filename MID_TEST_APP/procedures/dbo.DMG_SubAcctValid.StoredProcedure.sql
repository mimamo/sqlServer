USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SubAcctValid]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SubAcctValid]
	@CpnyID	varchar(10),
	@Sub	varchar(30)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	declare	@GLCpnyID varchar(10)

	-- Get the "account" company.
	select	@GLCpnyID = CpnySub
	from	vs_Company (NOLOCK)
	where	CpnyID = @CpnyID

	if (
	select	count(*)
	from	vs_SubXref (NOLOCK)
	where	CpnyID = @GLCpnyID
	and	Sub = @Sub
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
