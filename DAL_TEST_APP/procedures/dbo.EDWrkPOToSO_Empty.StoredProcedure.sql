USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_Empty]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDWrkPOToSO_Empty] As
Delete From EDWrkPOToSO
GO
