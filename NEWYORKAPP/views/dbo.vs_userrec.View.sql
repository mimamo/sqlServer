USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vs_userrec]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_userrec] AS SELECT * FROM DENVERSYS..userrec
GO
