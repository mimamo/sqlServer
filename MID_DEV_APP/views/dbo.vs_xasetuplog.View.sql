USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vs_xasetuplog]    Script Date: 12/21/2015 14:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_xasetuplog] AS SELECT * FROM DEN_DEV_SYS..xasetuplog
GO
