USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_0362Q]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--USETHISSYNTAX

CREATE PROCEDURE [dbo].[pb_0362Q] @RI_ID SMALLINT

AS

DECLARE @RI_Where VARCHAR(255), @Search VARCHAR(255), @Pos SMALLINT,
	@BegPerNbr VARCHAR(6), @EndPerNbr VARCHAR(6)

SELECT @RI_Where = LTRIM(RTRIM(RI_Where)), @BegPerNbr = BegPerNbr, @EndPerNbr = EndPerNbr
FROM RptRunTime
WHERE RI_ID = @RI_ID

SELECT @Search = "(RI_ID = " + RTRIM(CONVERT(VARCHAR(6),@RI_ID)) + ")"

SELECT @Pos = PATINDEX("%" + @Search + "%", @RI_Where)

UPDATE RptRunTime SET RI_Where = CASE
	WHEN @RI_Where IS NULL OR DATALENGTH(@RI_Where) <= 0
		THEN @Search
	WHEN @Pos <= 0
		THEN @Search + " AND (" + @RI_WHERE + ")"
END
WHERE RI_ID = @RI_ID
GO
