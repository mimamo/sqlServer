USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_UpdtLastOrdNbr]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOType_UpdtLastOrdNbr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@LastOrdNbr	varchar(10),
	@LUpd_DateTime	smalldatetime,
	@LUpd_Prog	varchar(8),
	@LUpd_User	varchar(10)
as
	update	SOType
	set	LastOrdNbr = @LastOrdNbr,
		LUpd_DateTime = @LUpd_DateTime,
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
GO
