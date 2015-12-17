USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOType_Fetch]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SOType_Fetch]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select	*
	from	SOType
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID
GO
