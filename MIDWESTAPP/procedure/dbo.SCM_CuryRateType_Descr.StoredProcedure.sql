USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_CuryRateType_Descr]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[SCM_CuryRateType_Descr]
	@CuryRtTpID	VARCHAR(10)
AS
	SELECT	Descr
		FROM	CuryRtTp (NOLOCK)
		WHERE	RateTypeId = @CuryRtTpID
GO
