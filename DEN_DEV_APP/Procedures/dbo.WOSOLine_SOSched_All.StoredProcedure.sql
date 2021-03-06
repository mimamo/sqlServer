USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOLine_SOSched_All]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOLine_SOSched_All]
   @CpnyID	varchar( 10 ),
   @OrdNbr     	varchar( 15 ),
   @LineRef    	varchar( 5 )

AS
   SELECT      *
   FROM        SOLine L JOIN SOSched S
               ON S.CpnyID = L.CpnyID and S.OrdNbr = L.OrdNbr and S.LineRef = L.LineRef
   WHERE       L.CpnyID = @CpnyID and
               L.OrdNbr = @OrdNbr and
               L.LineRef = @LineRef
GO
