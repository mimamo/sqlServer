USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequirement_DeleteAllRevised]    Script Date: 12/21/2015 13:57:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRRequirement_DeleteAllRevised] AS
	Delete from IRRequirement where  Revised = 1
GO
