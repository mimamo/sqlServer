USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_All_CpnyID_Status]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SOHeader_All_CpnyID_Status]
	@CpnyID		varchar(10),
	@Status		varchar(1)
as
	set nocount on

	select	*

	from	SOHeader

	where	CpnyID LIKE @CpnyID
	and	Status LIKE @Status

	order by CpnyID, OrdNbr
GO
