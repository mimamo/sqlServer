USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SalesOrd_All]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SalesOrd_All]
	@CpnyID char(10),
	@OrdNbr	char(10)
AS
	select
		*
	from
		SalesOrd
	where
		CpnyID = @CpnyID
	and
		OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
