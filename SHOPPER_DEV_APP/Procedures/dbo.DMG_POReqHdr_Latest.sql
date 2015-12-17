USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POReqHdr_Latest]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[DMG_POReqHdr_Latest]

	@ReqNbr varchar(15)
as

	Select	*
	From	POReqHdr
	Where	ReqNbr = @ReqNbr
	and	ReqCntr in (
			Select	MAX(Convert(Numeric,ReqCntr))
			From	POReqHdr
			Where	ReqNbr = @ReqNbr
			)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
