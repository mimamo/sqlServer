USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Check_Currency_EffData]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Check_Currency_EffData]
	@CuryEffDate	SMALLDATETIME,
	@CuryIDTo	VARCHAR(04),
	@CuryIDFrom	VARCHAR(04),
	@CuryRateType	VARCHAR(06)

AS
	SELECT	*
	FROM	CuryRate
	WHERE	EffDate <= @CuryEffDate
	and 	ToCuryID = @CuryIDTo
	and 	FromCuryID = @CuryIDFrom
	and 	RateType = @CuryRateType
	order by EffDate DESC
GO
