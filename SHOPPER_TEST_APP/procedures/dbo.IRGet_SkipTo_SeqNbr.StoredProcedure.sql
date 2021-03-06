USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRGet_SkipTo_SeqNbr]    Script Date: 12/21/2015 16:07:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Drop Proc IRGet_SkipT_oSeqNbr
CREATE procedure [dbo].[IRGet_SkipTo_SeqNbr]
	@cpnyid			varchar (10),
	@sotypeid		varchar (4),
	@currfunction		varchar (8),
	@currclass		varchar (4)
as
	declare	@SkipToSeq	varchar (4)
Set NoCount On
	-- Determine the Seq for the current function and class.
	select	@SkipToSeq = SkipTo
	from 	sostep
	where	cpnyid = @cpnyid
	  and	sotypeid = @sotypeid
	  and	functionid = @currfunction
	  and	functionclass = @currclass

	if @SkipToSeq IS NULL
	  select @SkipToSeq = ''
Set Nocount Off
Select @SkipToSeq As 'SkipToSeq'
GO
