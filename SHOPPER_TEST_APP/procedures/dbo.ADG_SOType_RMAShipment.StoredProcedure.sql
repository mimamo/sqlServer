USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_RMAShipment]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOType_RMAShipment]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select		*
	from		SOType
	where		CpnyID Like @CpnyID
	  and		SOTypeID Like @SOTypeID
	  and		Behavior Like 'RMSH'
	order by 	CpnyID,
			SOTypeID
GO
