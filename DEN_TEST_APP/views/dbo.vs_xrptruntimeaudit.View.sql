USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vs_xrptruntimeaudit]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_xrptruntimeaudit] AS SELECT * FROM DEN_TEST_SYS..xrptruntimeaudit
GO
