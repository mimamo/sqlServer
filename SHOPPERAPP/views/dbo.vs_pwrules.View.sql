USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vs_pwrules]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_pwrules] AS SELECT * FROM DENVERSYS..pwrules
GO
