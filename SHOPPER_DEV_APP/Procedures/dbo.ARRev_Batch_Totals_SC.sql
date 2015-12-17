USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_Batch_Totals_SC]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_Batch_Totals_SC    Script Date: 12/27/00 12:30:32 PM ******/
CREATE PROC [dbo].[ARRev_Batch_Totals_SC] @Batnbr varchar (10), @Ctrltot float, @CuryCtrltot float AS

UPDATE Batch
   SET CrTot = @ctrltot, Ctrltot = @Ctrltot,
       CuryCrtot = @curyCtrltot, CuryCtrltot = @CuryCtrltot
 WHERE batnbr = @batnbr AND module = 'AR'
GO
