USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_OrderTypeGeneratesPOs]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_OrderTypeGeneratesPOs]
	@CpnyID			varchar(10),
	@SOTypeID		varchar(4)
as

	SELECT	Count(*)
	FROM	SOSTEP
	WHERE	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
	  and	FunctionID = '6040000'
GO
