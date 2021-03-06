USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCodeEquip_Fault_Id]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smCodeEquip_Fault_Id]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smCodeEquip
	left outer join smEqUsage
		on smCodeEquip.UsageID = smEqUsage.UsageID
WHERE Fault_Id = @parm1
	AND smCodeEquip.UsageID LIKE @parm2
ORDER BY smCodeEquip.Fault_Id, smCodeEquip.UsageID
GO
