USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOSched_InvtID_Filter]    Script Date: 12/21/2015 16:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOSched_InvtID_Filter]
   	@InvtID     	varchar( 30 ),
   	@SiteID     	varchar( 10 ),
   	@CustID     	varchar( 15 ),
	@OrdDateFrom   	smallDateTime,
	@OrdDateTo	smallDateTime,
	@Status		varchar( 1 ),
	@SOType		varchar( 4 ),
	@CompFG		varchar( 1 )

AS
	if @CompFG = 'C'
		-- Components - Sales Items
	   SELECT      	L.*,
			H.BuildAvailDate,
			H.BuildInvtId,
			H.BuildQty,
			H.BuildSiteId,
			H.CpnyId,
			H.CustId,
			H.CustOrdNbr,
			H.OrdDate,
			H.OrdNbr,
			H.SoTypeId,
			H.Status,
			S.*
	   FROM        	SOLine L LEFT JOIN SOHeader H
	               	ON L.CpnyID = H.CpnyID and L.OrdNbr = H.OrdNbr
	               	JOIN SOSched S
	               	ON L.CpnyID = S.CpnyID and L.OrdNbr = S.OrdNbr and L.LineRef = S.LineRef
	   WHERE       	L.InvtID = @InvtID and
	               	S.SiteID LIKE @SiteID and
	               	H.CustID LIKE @CustID and
	               	H.OrdDate Between @OrdDateFrom and @OrdDateTo and
			S.Status LIKE @Status and
			H.SOTypeID LIKE @SOType
	   ORDER BY    	S.OrdNbr DESC, S.LineRef, S.SchedRef
	else
		-- Kit Assemblies
	   SELECT      	L.*,
			H.BuildAvailDate,
			H.BuildInvtId,
			H.BuildQty,
			H.BuildSiteId,
			H.CpnyId,
			H.CustId,
			H.CustOrdNbr,
			H.OrdDate,
			H.OrdNbr,
			H.SoTypeId,
			H.Status,
			S.*
	   FROM        	SOLine L LEFT JOIN SOHeader H
	               	ON L.CpnyID = H.CpnyID and L.OrdNbr = H.OrdNbr
	               	JOIN SOSched S
	               	ON L.CpnyID = S.CpnyID and L.OrdNbr = S.OrdNbr and L.LineRef = S.LineRef
	   WHERE       	H.BuildInvtID = @InvtID and
	               	H.BuildSiteID LIKE @SiteID and
	               	H.CustID LIKE @CustID and
	               	H.OrdDate Between @OrdDateFrom and @OrdDateTo and
			H.Status LIKE @Status and
			H.SOTypeID LIKE @SOType
	   ORDER BY    	H.OrdNbr DESC
GO
