USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Cury_Descr]    Script Date: 12/21/2015 14:17:55 ******/
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
