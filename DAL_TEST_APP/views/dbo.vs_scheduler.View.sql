USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vs_scheduler]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_scheduler] AS SELECT * FROM DEN_TEST_SYS..scheduler
GO
