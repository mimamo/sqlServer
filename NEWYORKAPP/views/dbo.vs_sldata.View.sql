USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vs_sldata]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_sldata] AS SELECT * FROM DENVERSYS..sldata
GO
