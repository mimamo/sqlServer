USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_POReceipt_Fetch]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_POReceipt_Fetch]
	@CpnyID		varchar(10),
	@BatNbr		varchar(10)
as
	select	*
	from	POReceipt
	where	CpnyID = @CpnyID
	and	BatNbr = @BatNbr
GO
