USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vs_access]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_access] AS SELECT * FROM DEN_DEV_SYS..access
GO
