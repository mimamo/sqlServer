USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wcpv_ShipToID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--This proc provides the possible-value list of inventory sites for a particular
--shopper.
CREATE Procedure [dbo].[wcpv_ShipToID]
	@CustID 	VARCHAR(15) = '%',
	@ShipToID 	VARCHAR(10) = '%'
As
		SELECT
		RTRIM(CustID) AS CustID,
		RTRIM(ShipToID) As ShipToID,
		RTRIM(Descr) As Descr
	FROM
		SOAddress (NOLOCK)
	WHERE
		CustID LIKE @CustID
		AND
		ShipTOID LIKE @ShipToID
	ORDER BY
		CustID,
		ShipToID
GO
