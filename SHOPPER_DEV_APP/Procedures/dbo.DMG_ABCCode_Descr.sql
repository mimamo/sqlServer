USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ABCCode_Descr]    Script Date: 12/16/2015 15:55:16 ******/
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
