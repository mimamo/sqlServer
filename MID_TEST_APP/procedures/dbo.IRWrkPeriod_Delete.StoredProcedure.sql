USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRWrkPeriod_Delete]    Script Date: 12/21/2015 15:49:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRWrkPeriod_Delete] As
	Delete From IRWrkPeriod
GO
