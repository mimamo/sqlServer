USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vp_ShareCpnyScreen]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_ShareCpnyScreen] AS

SELECT distinct FromCpny = c.FromCompany, ToCpny = c.ToCompany, Screen = s.Number, s.Module
FROM vs_InterCompany c, vs_Screen s
WHERE c.module = 'ZZ'
GO
