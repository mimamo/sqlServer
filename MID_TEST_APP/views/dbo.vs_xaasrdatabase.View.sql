USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vs_xaasrdatabase]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_xaasrdatabase] AS SELECT * FROM DEN_TEST_SYS..xaasrdatabase
GO
