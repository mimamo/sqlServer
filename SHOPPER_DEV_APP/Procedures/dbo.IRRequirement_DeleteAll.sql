USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequirement_DeleteAll]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRRequirement_DeleteAll] AS
Delete from IRRequirement
GO
