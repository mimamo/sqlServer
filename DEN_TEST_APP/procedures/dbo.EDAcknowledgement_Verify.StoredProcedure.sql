USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_Verify]    Script Date: 12/21/2015 15:36:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDAcknowledgement_Verify] @EntityType smallint, @IsaNbr int, @StNbr int, @GSRcvId varchar(15) As
Select Count(*), Max(EntityId) From EDAcknowledgement Where EntityType = @EntityType And IsaNbr = @IsaNbr And StNbr = @StNbr And GSRcvId = @GSRcvId
GO
