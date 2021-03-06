USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOSched_CustID]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOSched_CustID]
   @CustID     varchar( 15 ),
   @InvtID     varchar( 30 ),
   @OrdNbr     varchar( 15 )

AS
   SELECT      *
   FROM        SOHeader H JOIN SOLine L
               ON L.CpnyID = H.CpnyID and L.OrdNbr = H.OrdNbr
               JOIN SOSched S
               ON S.CpnyID = H.CpnyID and S.OrdNbr = H.OrdNbr and S.LineRef = L.LineRef
   WHERE       H.Custid = @CustID and
               L.Invtid = @InvtID and
               H.OrdNbr LIKE @OrdNbr
   ORDER BY    L.OrdNbr, L.LineRef, L.CpnyID
GO
