USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOType_Description]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOType_Description] @SOTypeId varchar(4) As
Select Descr From SOType Where SOTypeId = @SOTypeId
GO
