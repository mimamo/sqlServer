USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vw_acctsub]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_acctsub] AS SELECT * FROM DENVERSYS..acctsub
GO
