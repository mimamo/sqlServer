USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSubFRTable_FlatRateId]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSubFRTable_FlatRateId]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smSubFRTable
	left outer join ProductClass
		on smSubFRTable.ClassID = ProductClass.ClassId
WHERE FlatRateId = @parm1
	AND smSubFRTable.ClassID LIKE @parm2
ORDER BY smSubFRTable.FlatRateId
	,smSubFRTable.ClassID
GO
