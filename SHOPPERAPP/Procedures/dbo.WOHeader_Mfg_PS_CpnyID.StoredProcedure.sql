USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_Mfg_PS_CpnyID]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_Mfg_PS_CpnyID]
   @CpnyID	varchar( 10 ),
   @ProcStage  	varchar( 1 ),
   @WONbr      	varchar( 16 )
AS
   SELECT       *
   FROM         WOHeader
   WHERE        WOType IN ('M','R')
                and CpnyID = @CpnyID
                and ProcStage LIKE @ProcStage
                and WONbr LIKE @WONbr
				and Status <> 'H'
   ORDER BY     WONbr
GO
