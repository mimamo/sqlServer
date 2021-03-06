USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_GetNewDraftNbr]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_GetNewDraftNbr]  @DraftNbr varchar(10) OUTPUT
AS

SELECT
	@DraftNbr = LastUsed_2
FROM
	PJDOCNUM
WHERE
	ID = 2

UPDATE PJDOCNUM
SET LastUsed_2 = RIGHT('0000000000' + CAST((LastUsed_2 + 1) as varchar(10)), 10)
WHERE
	ID = 2
GO
