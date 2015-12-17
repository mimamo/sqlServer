USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPJProj_spk5_No_WO]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPJProj_spk5_No_WO]
	@Project		varchar( 16 )
AS
	SELECT			*
	FROM			PJPROJ
	WHERE			Project like @Project
				and status_pa = 'A'
				and status_ar = 'A'
				and status_20 = '' 		-- WOs have Status_20 filled with WOType
	ORDER BY		Project
GO
