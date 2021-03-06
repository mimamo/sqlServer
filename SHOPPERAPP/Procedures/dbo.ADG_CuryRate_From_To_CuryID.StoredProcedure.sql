USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CuryRate_From_To_CuryID]    Script Date: 12/21/2015 16:12:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ADG_CuryRate_From_To_CuryID]

	@CuryId1	varchar(4),
	@CuryId2	varchar(4),
	@RateType	varchar(6)
as
	select	*
	from	CuryRate
	where	((FromCuryId = @CuryId1 and ToCuryId = @CuryId2) or
		(FromCuryId = @CuryId2 and ToCuryId = @CuryId1)) and
		RateType = @RateType
	Order By EffDate desc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
