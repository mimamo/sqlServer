USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ABCCode_Descr]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ABCCode_Descr]
	@ABCCode		varchar( 2 )
AS
	SELECT 			Descr
	FROM 			PIABC
	WHERE 			ABCCode = @ABCCode
GO
