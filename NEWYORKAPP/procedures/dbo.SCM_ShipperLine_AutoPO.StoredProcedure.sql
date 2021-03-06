USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ShipperLine_AutoPO]    Script Date: 12/21/2015 16:01:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_ShipperLine_AutoPO]
	@CpnyID			varchar(10),
	@ShipperID		varchar(30),
	@ShipperLineRef 	varchar(10)
as
	select	top 1 os.AutoPO

	from	SOSched os

	  join	SOShipSched ss
	  on	ss.CpnyID = os.CpnyID
	  and	ss.OrdNbr = os.OrdNbr
	  and	ss.OrdLineRef = os.LineRef
	  and	ss.OrdSchedRef = os.SchedRef

	where	ss.CpnyID = @CpnyID
	  and	ss.ShipperID = @ShipperID
	  and	ss.ShipperLineRef = @ShipperLineRef
GO
