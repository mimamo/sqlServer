USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vr_PSSSysObjects]    Script Date: 12/21/2015 13:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_PSSSysObjects] AS
  SELECT [Name] = CONVERT(VARCHAR(30), [Name]) FROM SysObjects WHERE UID = 1 AND XType = 'U'
GO
