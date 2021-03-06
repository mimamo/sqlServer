USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipHeader_Clsd_SRegID]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipHeader_Clsd_SRegID]
	@CpnyID varchar(10), @RI_WHERE varchar(255)
AS

if RTRIM(@RI_WHERE) <> '' SELECT @RI_WHERE = ' AND (' + @RI_WHERE + ')'

exec('	Select	CpnyID,
		ShipperID,
		InvcNbr
	From	SOShipHeader (NOLOCK)
	Where	Status = ''C''
	And 	ShipRegisterID = ''''
	And 	ConsolInv = 0
	and	CpnyID = '''+ @CpnyID + '''' + @RI_WHERE)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
