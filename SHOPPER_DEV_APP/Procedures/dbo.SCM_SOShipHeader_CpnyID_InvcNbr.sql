USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_SOShipHeader_CpnyID_InvcNbr]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_SOShipHeader_CpnyID_InvcNbr]
	@CpnyID varchar( 10 ),
	@InvcNbr varchar( 15 )
AS
	SELECT *
	FROM SOShipHeader
	WHERE CpnyID = @CpnyID
	   AND InvcNbr = @InvcNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
