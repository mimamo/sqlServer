USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_UpdateAck]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDAcknowledgement_UpdateAck] @EntityType smallint, @EntityId varchar(20), @ISANbr int, @STNbr int, @GSRcvId varchar(15) As
Update EDAcknowledgement Set AckStatus = 1, AckDate = GetDate() Where EntityType = @EntityType And EntityId = @EntityId And ISANbr = @ISANbr And STNbr = @STNbr And GSRcvId = @GSRcvId
GO
