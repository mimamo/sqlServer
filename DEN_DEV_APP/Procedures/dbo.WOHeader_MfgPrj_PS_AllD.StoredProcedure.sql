USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_MfgPrj_PS_AllD]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- ----------------------------------------------------------------------------------------------------------
-- procedure name fixed v-benste (was previously dboWOHeader_MfgPrj_PS_AllD)
-- code reviewed v-bbinkl
-- ---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[WOHeader_MfgPrj_PS_AllD]
   @CpnyID	varchar( 10 ),
   @ProcStage  	varchar( 1 ),
   @WONbr      	varchar( 16 )

AS
   SELECT       *
   FROM         WOHeader LEFT JOIN PJProj
                ON WOHeader.WONbr = PJProj.Project
   WHERE        WOHeader.CpnyID = @CpnyID
                and (ProcStage = ' ' or ProcStage = @ProcStage)
                and WONbr LIKE @WONbr
				and WOHeader.Status <> 'H'
   ORDER BY     WOHeader.WONbr
GO
