USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOType_Behavior]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOType_Behavior] @CpnyId varchar(10), @SOTypeId varchar(4) As
Select Behavior From SOType Where CpnyId = @CpnyId And SOTypeId = @SOTypeId
GO
