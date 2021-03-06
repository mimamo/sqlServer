USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConPricing_all]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConPricing_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM smConPricing
		left outer join Inventory
			on smConPricing.Invtid = Inventory.Invtid
	WHERE ContractID LIKE @parm1
	   AND smConPricing.Invtid LIKE @parm2
	ORDER BY ContractID,
	   smConPricing.Invtid
GO
