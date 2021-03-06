USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pb_03030]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[pb_03030] @RI_ID SMALLINT

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

DECLARE	@BatNbr CHAR(10)

SELECT	@BatNbr = SUBSTRING(RI_WHERE, CHARINDEX('''', RI_WHERE) + 1,
                            CASE WHEN CHARINDEX( '''', RI_WHERE, CHARINDEX('''', RI_WHERE) + 1) = 0 THEN 0
				 ELSE CHARINDEX( '''', RI_WHERE, CHARINDEX('''', RI_WHERE) + 1) - 1 - CHARINDEX('''', RI_WHERE)
			    END)
FROM	RptRuntime
WHERE	RI_ID = @RI_ID

UPDATE	RptRuntime SET
	ReportTitle = v.Name
FROM	Batch b INNER JOIN vs_Screen v ON v.Number = RTRIM(b.EditScrnNbr) + '00'
WHERE	b.BatNbr = @BatNbr AND b.Module = 'AP' AND RI_ID = @RI_ID
GO
