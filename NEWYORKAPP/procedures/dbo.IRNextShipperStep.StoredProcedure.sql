USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRNextShipperStep]    Script Date: 12/21/2015 16:01:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRNextShipperStep] @NextFunctionID varchar(8), @NextClassID varchar(4), @CpnyID varchar(10), @ShipperID varchar(15) AS
Select * from soshipheader
where NextFunctionID = @NextFunctionID and NextFunctionClass = @NextClassID and CpnyID like @CpnyID and ShipperId like @ShipperID
order by CpnyID,ShipperID
GO
