USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_RptControl_GetFrmtAndName]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_RptControl_GetFrmtAndName]
	@ReportNbr char(5)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	ReportFormat00, ReportFormat01, ReportFormat02,
		ReportFormat03, ReportFormat04, ReportFormat05,
		ReportFormat06, ReportFormat07, ReportName00,
		ReportName01, ReportName02, ReportName03,
		ReportName04, ReportName05, ReportName06,
		ReportName07
	from	vs_RptControl
	where	ReportNbr = @ReportNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
