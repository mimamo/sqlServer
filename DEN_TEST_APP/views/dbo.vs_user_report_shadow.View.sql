USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vs_user_report_shadow]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_user_report_shadow] AS SELECT * FROM DEN_TEST_SYS..user_report_shadow
GO
