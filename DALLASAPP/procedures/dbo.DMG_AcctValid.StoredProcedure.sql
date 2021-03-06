USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_AcctValid]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_AcctValid]
	@CpnyID	varchar(10),
	@Acct	varchar(10)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	declare	@GLCpnyID varchar(10)

	-- Get the "account" company.
	select	@GLCpnyID = CpnyCOA
	from	vs_Company (NOLOCK)
	where	CpnyID = @CpnyID

	if (
	select	count(*)
	from	vs_AcctXref (NOLOCK)
	where	CpnyID = @GLCpnyID
	and	Acct = @Acct
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
