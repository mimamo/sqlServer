USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_VerifyCustId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDAcknowledgement_VerifyCustId] @EntityType smallint, @IsaNbr int, @StNbr int, @CustId varchar(15) As
If @EntityType = 1
  Select Count(*), Max(A.EntityId) From EDAcknowledgement A Inner Join SOShipHeader B On A.EntityId = B.InvcNbr
    Where A.Isanbr =  IsaNbr And A.StNbr = @StNbr And B.CustId = @CustId And A.EntityType = 1
Else
  Select Count(*), Max(EntityId) From EDAcknowledgement Where EntityType = 2 And IsaNbr = @IsaNbr And StNbr = @StNbr
GO
