USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_LookUp]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDAcknowledgement_LookUp] @EntityId varchar(20), @EntityType smallint As
Select * From EDAcknowledgement Where EntityId = @EntityId And EntityType = @EntityType
GO
