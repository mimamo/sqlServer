USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSOAdd_CustId_ShiptoId]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSOAdd_CustId_ShiptoId]
	@parm1 varchar(15)
	,@parm2 varchar(10)
AS
SELECT *
FROM SOAddress
	left outer join smSOAddress
		on SOAddress.Custid = smSOAddress.Custid
		and SOAddress.ShiptoId = smSOAddress.ShiptoId
WHERE SOAddress.Custid = @parm1
	AND SOAddress.ShiptoId LIKE @parm2
ORDER BY SOAddress.Custid
	,SOAddress.Shiptoid
GO
