USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetCompanyBaseCuryID]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetCompanyBaseCuryID]
	@CpnyID		varchar(10),
	@BaseCuryID	varchar(4) OUTPUT

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	select	@BaseCuryID = ltrim(rtrim(BaseCuryID))
	from	vs_Company (NOLOCK)
	where	CpnyID = @CpnyID

	if @@ROWCOUNT = 0 begin
		set @BaseCuryID = ''
		return 0	--Failure
	end
	else begin
		--select @BaseCuryID
		return 1	--Success
	end
GO
