USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vw_acctxref]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_acctxref] AS SELECT * FROM DEN_DEV_SYS..acctxref
GO
