USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vw_acctsub]    Script Date: 12/21/2015 15:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_acctsub] AS SELECT * FROM DENVERSYS..acctsub
GO
