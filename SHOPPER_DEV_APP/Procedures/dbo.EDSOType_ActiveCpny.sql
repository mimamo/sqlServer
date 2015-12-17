USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOType_ActiveCpny]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOType_ActiveCpny] @CpnyId varchar(10), @SOTypeId varchar(4) As
Select * From SOType Where CpnyId Like @CpnyId And Active = 1 And SOTypeId Like @SOTypeId
Order By SOTypeId
GO
