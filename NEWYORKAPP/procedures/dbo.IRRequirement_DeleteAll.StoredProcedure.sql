USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequirement_DeleteAll]    Script Date: 12/21/2015 16:01:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRRequirement_DeleteAll] AS
Delete from IRRequirement
GO
