USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vs_xaaccessdetrights]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_xaaccessdetrights] AS SELECT * FROM DEN_DEV_SYS..xaaccessdetrights
GO
