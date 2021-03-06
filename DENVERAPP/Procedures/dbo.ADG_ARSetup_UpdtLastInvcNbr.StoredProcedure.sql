USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARSetup_UpdtLastInvcNbr]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARSetup_UpdtLastInvcNbr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@LastInvcNbr	varchar(10),
	@LUpd_DateTime	smalldatetime,
	@LUpd_Prog	varchar(8),
	@LUpd_User	varchar(10)
as

	update	ARSetup
	set	LastRefNbr = reverse(stuff(reverse(rtrim(LastRefNbr)),1,len(rtrim(@LastInvcNbr)), reverse(rtrim(@LastInvcNbr)))),
		LUpd_DateTime = @LUpd_DateTime,
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User
GO
