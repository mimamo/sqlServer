USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vs_kpi]    Script Date: 12/21/2015 13:44:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_kpi] AS SELECT * FROM DENVERSYS..kpi
GO
