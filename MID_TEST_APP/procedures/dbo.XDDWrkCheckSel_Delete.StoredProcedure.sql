USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDWrkCheckSel_Delete]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDWrkCheckSel_Delete]
   @AccessNbr		smallint
AS

   DELETE 
   FROM 	XDDWrkCheckSel 
   WHERE	AccessNbr = @AccessNbr
GO
