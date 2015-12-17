USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_StepCredChk]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_StepCredChk]
 	@CpnyID		varchar(10),
	@SOTypeID	varchar(4),
	@FunctionID	varchar(8),
	@FunctionClass	varchar(4)
as
	select	CreditChk
	from	SOStep WITH (NOLOCK)
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
	  and	FunctionID = @FunctionID
	  and	FunctionClass = @FunctionClass
GO
