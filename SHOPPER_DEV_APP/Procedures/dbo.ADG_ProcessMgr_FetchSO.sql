USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_FetchSO]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_ProcessMgr_FetchSO]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	select		H.CustID,
			H.LUpd_Prog,
			T.Behavior,
			H.AdminHold

	from		SOHeader H
	join		SOType T (nolock)
	on		T.SOTypeID = H.SOTypeID

	where		H.CpnyID = @CpnyID
	and		H.OrdNbr = @OrdNbr
GO
