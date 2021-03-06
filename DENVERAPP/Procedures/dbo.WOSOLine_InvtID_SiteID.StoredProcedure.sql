USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOLine_InvtID_SiteID]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOLine_InvtID_SiteID]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 )

AS
   SELECT   L.OrdNbr,
            L.LineRef,
            L.CpnyID,
            L.InvtID,
            L.SiteID,
            H.Status,
            H.CustID,
            S.PromDate,
            S.QtyOrd,
            S.QtyShip,
            H.NextFunctionID,
            L.CnvFact,
            L.UnitMultDiv
   FROM     SOLine L JOIN SOHeader H
            ON L.CpnyID = H.CpnyID and L.OrdNbr = H.OrdNbr
            JOIN SOSched S
            ON L.CpnyID = S.CpnyID and L.OrdNbr = S.OrdNbr and L.LineRef = S.LineRef
   WHERE    L.InvtID = @InvtID and
            L.SiteID LIKE @SiteID
   ORDER BY L.OrdNbr DESC, L.LineRef, L.CpnyID
GO
