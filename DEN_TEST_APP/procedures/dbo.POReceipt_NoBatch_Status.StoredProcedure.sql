USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_NoBatch_Status]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_NoBatch_Status    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_NoBatch_Status] @parm1 varchar ( 01) As
        Select * from POReceipt where
                BatNbr = '' And
                Status = @parm1
        Order by CuryID, RcptNbr
GO
