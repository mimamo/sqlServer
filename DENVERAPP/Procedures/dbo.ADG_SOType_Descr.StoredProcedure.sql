USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_Descr]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOType_Descr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select	Descr
	from	SOType (nolock)
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
GO
