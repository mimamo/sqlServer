USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_GetNewChargeBatchNbr]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_GetNewChargeBatchNbr]  @BatNbr varchar(10) OUTPUT
AS


UPDATE PJDOCNUM
SET LastUsed_chargh = RIGHT('0000000000' + CAST((LastUsed_chargh + 1) as varchar(10)), 10)
WHERE
	ID = 14

SELECT
	@BatNbr = LastUsed_chargh
FROM
	PJDOCNUM
WHERE
	ID = 14
GO
