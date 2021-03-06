USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SELECT_QtyOpenShip_SOSched]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SELECT_QtyOpenShip_SOSched] @CpnyID varchar(10), @OrdNbr varchar(15), @LineRef varchar(5), @ShipToID VarChar(10), @ShipperID	varchar(15)

AS 
SELECT s.* 
  FROM SOSCHED s JOIN SOShipSched p WITH(NOLOCK)
                 ON s.OrdNbr = p.ordnbr
                AND s.LineRef = p.OrdLineRef
                AND s.SchedRef = p.OrdSchedRef
                AND s.CpnyID = p.CpnyID
 WHERE s.CpnyID = @CpnyID        
   AND s.OrdNbr = @OrdNbr        
   AND s.LineRef = @LineRef      
   AND s.ShipToID = @ShipToID  
   AND p.ShipperID = @ShipperID    
 ORDER BY s.SchedRef Desc
GO
