USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vs_xasetuplog]    Script Date: 12/21/2015 16:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_xasetuplog] AS SELECT * FROM DEN_TEST_SYS..xasetuplog
GO
