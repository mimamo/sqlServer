USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vs_xasetuplog]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_xasetuplog] AS SELECT * FROM DENVERSYS..xasetuplog
GO
