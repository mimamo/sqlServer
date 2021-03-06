USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOSched_SiteID]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_PO_SOSched_SiteID]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@LineRef varchar(5),
	@SchedRef varchar(5),
	@SiteID varchar(10) OUTPUT
as
	select	@SiteID = ltrim(rtrim(SiteID))
	from	SOSched (NOLOCK)
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	LineRef = @LineRef
	and	SchedRef = @SchedRef

	if @@ROWCOUNT = 0 begin
		set @SiteID = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
