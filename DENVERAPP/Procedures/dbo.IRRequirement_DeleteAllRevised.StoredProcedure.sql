USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequirement_DeleteAllRevised]    Script Date: 12/21/2015 15:42:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRRequirement_DeleteAllRevised] AS
	Delete from IRRequirement where  Revised = 1
GO
