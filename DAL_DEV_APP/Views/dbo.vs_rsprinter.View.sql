USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vs_rsprinter]    Script Date: 12/21/2015 13:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_rsprinter] AS SELECT * FROM DEN_DEV_SYS..rsprinter
GO
