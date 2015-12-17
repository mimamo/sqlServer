USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDGet_BaseCuryID_Prec]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDGet_BaseCuryID_Prec]
AS
	
	-- Get GL Base CuryID
	-- Get GL Base Currency Precision
	SELECT		G.BaseCuryID,
			C.DecPl
	FROM		GLSetup G (nolock) JOIN Currncy C (nolock)
                        ON G.BaseCuryID = C.Curyid
GO
