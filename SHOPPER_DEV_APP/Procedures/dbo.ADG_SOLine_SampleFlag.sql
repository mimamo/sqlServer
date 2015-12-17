USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOLine_SampleFlag]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOLine_SampleFlag]
	@InvtID   varchar(30),
    @OrdNbr   varchar(15),
	@LineRef  varchar(5),
	@CpnyId   varchar(10)
as
	declare	@Sample	smallint	-- logical
	
	select	@Sample = Sample

	from	SOLine (nolock)
	where	InvtID = @Invtid  AND
            CpnyID = @CpnyID  AND
            OrdNbr = @OrdNbr  AND
            LineRef = @LineRef

    Select @Sample
GO
