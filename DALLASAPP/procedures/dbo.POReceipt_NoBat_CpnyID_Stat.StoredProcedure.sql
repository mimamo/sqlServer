USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_NoBat_CpnyID_Stat]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_NoBat_CpnyID_Stat    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_NoBat_CpnyID_Stat] @parm1 varchar ( 10), @parm2 varchar(1) As
        Select * from POReceipt where
                BatNbr = '' And
                Status = @parm2 And
                CpnyID = @parm1
        Order by CuryID, RcptNbr
GO
