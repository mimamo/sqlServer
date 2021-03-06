USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_PONbr_Valid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_PONbr_Valid]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@RcptType	varchar(1)
as
	if @RcptType = 'R' begin
		if (
		select	count(*)
		from 	PurchOrd (NOLOCK)
        	where 	CpnyID = @CpnyID
		and	PONbr = @PONbr
		and	POType = 'OR'
		and	Status in ('O','P')
 		) = 0
			--select 0
			return 0	--Failure
		else
			--select 1
			return 1	--Success
	end
	else if @RcptType = 'X' begin
		if (
		select	count(*)
		from 	PurchOrd (NOLOCK)
        	where 	CpnyID = @CpnyID
		and	PONbr = @PONbr
		and	POType = 'OR'
		and	RcptStage in ('F','P')
 		) = 0
			--select 0
			return 0	--Failure
		else
			--select 1
			return 1	--Success
	end
	else
		--select 0
		return 0	--Failure
GO
