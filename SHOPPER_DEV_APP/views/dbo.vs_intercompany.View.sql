USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vs_intercompany]    Script Date: 12/21/2015 14:33:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_intercompany] AS SELECT * FROM DEN_DEV_SYS..intercompany
GO
