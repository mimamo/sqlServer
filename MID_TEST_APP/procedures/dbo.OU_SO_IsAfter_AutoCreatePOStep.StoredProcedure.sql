USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[OU_SO_IsAfter_AutoCreatePOStep]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[OU_SO_IsAfter_AutoCreatePOStep]
	@CpnyID			varchar (10),
	@OrdNbr			varchar (15)
as
	declare	@SOTypeID	varchar (4)
	declare	@CurrSeq	varchar (4)

	-- Get the Order Step for the SO's Next Step
	select	@SOTypeID = SOStep.SOTypeID,
		@CurrSeq = SOStep.Seq
	from	SOStep
	join	SOHeader
	on	SOStep.SOTypeID = SOHeader.SOTypeID
	and	SOStep.CpnyID = SOHeader.CpnyID
	and	SOStep.FunctionID = SOHeader.NextFunctionID
	and	SOStep.FunctionClass = SOHeader.NextFunctionClass
	where	SOHeader.OrdNbr = @OrdNbr

	-- See if the Auto Create PO Step is before the current step
	select	count(*)
	from	SOStep
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID
	and	Status <> 'D'
	and	Seq < @CurrSeq
	and	FunctionID = '6040000'
	and	AutoPgmID not like 'x%'
GO
