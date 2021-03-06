USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOTypeDescr]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOTypeDescr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@Descr		varchar(30) OUTPUT
as
	select	@Descr = ltrim(rtrim(Descr))
	from	SOType (NOLOCK)
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID

	if @@ROWCOUNT = 0
		return 0
	else
		return 1
GO
