USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vs_mbfworkfloweventlog]    Script Date: 12/21/2015 13:44:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_mbfworkfloweventlog] AS SELECT * FROM DENVERSYS..mbfworkfloweventlog
GO
