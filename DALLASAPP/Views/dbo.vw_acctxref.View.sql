USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vw_acctxref]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_acctxref] AS SELECT * FROM DENVERSYS..acctxref
GO
