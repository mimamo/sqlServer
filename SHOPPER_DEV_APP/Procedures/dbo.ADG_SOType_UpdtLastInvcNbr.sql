USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_UpdtLastInvcNbr]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOType_UpdtLastInvcNbr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@LastInvcNbr	varchar(10),
	@LUpd_DateTime	smalldatetime,
	@LUpd_Prog	varchar(8),
	@LUpd_User	varchar(10)
as

	update	SOType
	set	LastInvcNbr = @LastInvcNbr,
		LUpd_DateTime = @LUpd_DateTime,
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
GO
