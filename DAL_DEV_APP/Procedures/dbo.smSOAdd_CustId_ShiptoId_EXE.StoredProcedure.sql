USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSOAdd_CustId_ShiptoId_EXE]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSOAdd_CustId_ShiptoId_EXE]
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
