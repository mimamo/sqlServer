USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_01303]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[pb_01303] @RI_ID SMALLINT

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

DECLARE	@StartW	SMALLINT
DECLARE	@EndW	SMALLINT
DECLARE	@StartR	SMALLINT
DECLARE	@EndR	SMALLINT
DECLARE	@CpnyID	CHAR(10)

SELECT	@StartW = CHARINDEX(' AND CpnyID= ''', RI_Where),
	@EndW = CHARINDEX('''', RI_Where, CHARINDEX(' AND CpnyID= ''', RI_Where) + 14) + 1,
	@StartR = CHARINDEX(' AND CpnyID= ''', RI_Replace),
	@EndR = CHARINDEX('''', RI_Replace, CHARINDEX(' AND CpnyID= ''', RI_Replace) + 14) + 1,
	@CpnyID = SUBSTRING(RI_Where, CHARINDEX(' AND CpnyID= ''', RI_Where) + 14,
	CHARINDEX('''', RI_Where, CHARINDEX(' AND CpnyID= ''', RI_Where) + 14) -
	CHARINDEX(' AND CpnyID= ''', RI_Where) - 14)
FROM	RptRuntime
WHERE	RI_ID = @RI_ID

UPDATE	RptRuntime SET
	ReportTitle = ReportFormat,
--	RI_Report = ReportFormat,
--	RI_WTitle = ReportFormat,
	CpnyID = @CpnyID,
	CmpnyName = c.CpnyName,
	RI_Where = STUFF(RI_Where, @StartW, @EndW - @StartW, ' '),
	RI_Replace = STUFF(RI_Replace, @StartR, @EndR - @StartR, '')
FROM	vs_Company c
WHERE	RptRuntime.RI_ID = @RI_ID AND c.CpnyID = @CpnyID
GO
