USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CustContactValid]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CustContactValid]
	@CustID		varchar(15),
	@Type		varchar(2),
	@ContactID	varchar(10)
as
	if (
	select	count(*)
	from	CustContact (NOLOCK)
	where	CustID = @CustID
	and	Type = @Type
	and	ContactID = @ContactID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
