USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vs_appsrvrequest]    Script Date: 12/21/2015 14:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_appsrvrequest] AS SELECT * FROM DEN_TEST_SYS..appsrvrequest
GO
