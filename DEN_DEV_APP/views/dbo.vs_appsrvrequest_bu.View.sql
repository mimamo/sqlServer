USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vs_appsrvrequest_bu]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_appsrvrequest_bu] AS SELECT * FROM DEN_DEV_SYS..appsrvrequest_bu
GO
