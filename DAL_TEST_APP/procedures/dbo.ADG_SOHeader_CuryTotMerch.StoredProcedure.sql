USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_CuryTotMerch]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOHeader_CuryTotMerch]
	@CpnyID varchar(10),
	@OrdNbr varchar(15)
AS
	SELECT CuryTotMerch
	FROM SOHeader
	Where CpnyID = @CpnyID AND
		OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
