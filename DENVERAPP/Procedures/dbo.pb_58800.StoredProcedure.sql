USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pb_58800]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_58800] @RI_ID SMALLINT

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
