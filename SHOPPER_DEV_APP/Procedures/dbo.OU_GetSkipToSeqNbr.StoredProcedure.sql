USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OU_GetSkipToSeqNbr]    Script Date: 12/21/2015 14:34:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[OU_GetSkipToSeqNbr]
	@CpnyID			varchar (10),
	@SOTypeID		varchar (4),
	@CurrFunction		varchar (8),
	@CurrClass		varchar (4)
as
	set nocount on

	declare	@SkipToSeq	varchar (4)

	-- Determine the Seq for the current function and class.
	select	@SkipToSeq = SkipTo
	from 	SOStep
	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID
	and	FunctionID = @CurrFunction
	and	FunctionClass = @CurrClass

	if @SkipToSeq is null
		select @SkipToSeq = ''

	select @SkipToSeq as 'SkipToSeq'
GO
