USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vs_mbfrunningprocess]    Script Date: 12/21/2015 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_mbfrunningprocess] AS SELECT * FROM DEN_TEST_SYS..mbfrunningprocess
GO
