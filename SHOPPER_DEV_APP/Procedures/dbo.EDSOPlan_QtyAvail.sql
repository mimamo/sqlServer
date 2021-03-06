USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOPlan_QtyAvail]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOPlan_QtyAvail] @InvtId varchar(30), @SiteId varchar(10), @CpnyId varchar(10), @OrdNbr varchar(15) As
Select Sum(Qty) From SOPlan Where InvtId = @InvtId And SiteId = @SiteId And DisplaySeq <
(Select Min(DisplaySeq) From SOPlan Where InvtId = @InvtId And SiteId = @SiteId And
CpnyId = @CpnyId And SOOrdNbr = @OrdNbr)
GO
