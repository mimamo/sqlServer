USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcEq_Custid_SiteID]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcEq_Custid_SiteID]
		@parm1	varchar(15)
		,@parm2 varchar (10)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smSvcEquipment
	WHERE
		Status = 'A'
			AND
		(CustId LIKE @parm1
			OR
		 CustID = '')
			AND
		(SiteID LIKE @parm2
			OR
		SiteID = '' )
			AND
		EquipID LIKE @parm3
	ORDER BY
		EquipID
GO
