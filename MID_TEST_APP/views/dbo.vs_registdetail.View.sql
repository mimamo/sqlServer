USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vs_registdetail]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_registdetail] AS SELECT * FROM DEN_TEST_SYS..registdetail
GO
