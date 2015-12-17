USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_LookUpNotSentNoAck]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDAcknowledgement_LookUpNotSentNoAck] @EntityId varchar(20), @EntityType smallint As
Select * From EDAcknowledgement Where EntityId = @EntityId And EntityType = @EntityType And ISANbr = 0 And STNbr = 0
GO
