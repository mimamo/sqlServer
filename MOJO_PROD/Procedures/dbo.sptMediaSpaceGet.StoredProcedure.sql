USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaSpaceGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaSpaceGet]
	@MediaSpaceKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/03/13  MAS 10.5.6.9 Created
|| 09/18/13  CRG 10.5.7.2 Added UsingMultipleQty column
*/
		SELECT tMediaUnitType.UnitTypeName, tMediaUnitType.UnitTypeID,
		 tMediaSpace.*,
		CASE ISNULL(tMediaUnitType.Qty1, '') 
			WHEN '' THEN ISNULL(tMediaSpace.Qty1,0)
			ELSE ISNULL(tMediaSpace.Qty1,0) * ISNULL(tMediaSpace.Qty2, 0)
		END AS Quantity,
		CASE ISNULL(tMediaUnitType.Qty1, '') 
			WHEN '' THEN 0
			ELSE 1
		END AS UsingMultipleQty
		FROM tMediaSpace (nolock)
		JOIN tMediaUnitType (nolock) on tMediaUnitType.MediaUnitTypeKey = tMediaSpace.MediaUnitTypeKey
		WHERE
			MediaSpaceKey = @MediaSpaceKey
GO
