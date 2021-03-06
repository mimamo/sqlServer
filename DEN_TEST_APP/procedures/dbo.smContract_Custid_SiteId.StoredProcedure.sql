USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Custid_SiteId]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContract_Custid_SiteId]
	@parm1 varchar(15)
	,@parm2 varchar(10)
	,@parm3 varchar(10)
AS
SELECT *
FROM smContract
	Left outer join soAddress
		on SoAddress.ShipToId = smContract.SiteId
		and SoAddress.CustId = smContract.CustId
WHERE smContract.CustId = @parm1
	AND smContract.SiteId = @parm2
	AND smContract.ContractID LIKE @parm3
	AND smContract.Status = 'A'
ORDER BY smContract.CustId
	,smContract.SiteId
	,smContract.ContractID
GO
