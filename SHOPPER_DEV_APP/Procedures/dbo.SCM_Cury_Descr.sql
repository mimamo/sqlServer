USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Cury_Descr]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[SCM_Cury_Descr]
	@CuryID	VARCHAR(10)
AS
	SELECT	Descr
		FROM	Currncy (NOLOCK)
		WHERE	CuryID = @CuryID
GO
