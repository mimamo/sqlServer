USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_VendIDValid]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_VendIDValid]
	@VendID		varchar(15)
as
	if (
	select	count(*)
	from	Vendor (NOLOCK)
	where	VendID = @VendID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
