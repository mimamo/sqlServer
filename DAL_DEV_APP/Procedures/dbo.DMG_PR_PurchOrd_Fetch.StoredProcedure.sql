USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_PurchOrd_Fetch]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_PurchOrd_Fetch]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@RcptType	varchar(1)
as
	if @RcptType = 'R'
		select	*
		from 	PurchOrd (NOLOCK)
        	where 	CpnyID = @CpnyID
		and	PONbr = @PONbr
		and	POType = 'OR'
		and	Status in ('O','P')
	else if @RcptType = 'X'
		select	*
		from 	PurchOrd (NOLOCK)
        	where 	CpnyID = @CpnyID
		and	PONbr = @PONbr
		and	POType = 'OR'
		and	RcptStage in ('F','P')
	else
		select	*
		from 	PurchOrd (NOLOCK)
        	where 	1=0
GO
