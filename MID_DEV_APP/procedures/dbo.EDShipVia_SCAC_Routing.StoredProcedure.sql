USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_SCAC_Routing]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipVia_SCAC_Routing] @CpnyID varchar(10), @SCAC varchar(5), @Routing as varchar(50) AS
Declare @ShipViaID  as varchar(15)
Select @ShipViaID = ShipViaId from Shipvia (NOLOCK) where @CpnyID = cpnyid and SCAC = @SCAC
if isnull(@ShipViaID,'~') = '~'
   begin
      Select @ShipViaID = ShipViaId from Shipvia (NOLOCK) where @CpnyID = cpnyid and EDIViaCode = left(@Routing,20)
   End
Select @ShipViaId
GO
