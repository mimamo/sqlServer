USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CheckForLandedCosts]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CheckForLandedCosts]
	@RcptNbr 	varchar (10)
	AS
	select 	Count(*)
	from 	INTran
	where 	RcptNbr = @RcptNbr
	and	TranType = 'AJ'
	and	JrnlType = 'LC'

-- Copyright 2002 by Advanced Distribution Group, Ltd. All rights reserved.
GO
