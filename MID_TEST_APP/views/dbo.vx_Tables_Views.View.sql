USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vx_Tables_Views]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vx_Tables_Views]
AS
SELECT LEFT(Name, 20) AS Name
FROM Sysobjects
WHERE xtype IN ('U', 'V')
GO
