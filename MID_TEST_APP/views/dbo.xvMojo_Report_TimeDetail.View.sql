USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvMojo_Report_TimeDetail]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvMojo_Report_TimeDetail]
AS
SELECT     *
FROM         OPENQUERY(sqlwmj, 'Select * from MOjo_prod.dbo.vReport_TimeDetail') AS derivedtbl_1
GO
