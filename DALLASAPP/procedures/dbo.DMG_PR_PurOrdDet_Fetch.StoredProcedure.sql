USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_PurOrdDet_Fetch]    Script Date: 12/21/2015 13:44:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_PurOrdDet_Fetch]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@LineRef	varchar(5)
as
	select	*
	from	PurOrdDet (NOLOCK)
        where 	PONbr = @PONbr
	and	LineRef like @LineRef
        and	PurchaseType in ('DL','FR','GI','GP','GS','MI','GN')
	order by LineNbr
GO
