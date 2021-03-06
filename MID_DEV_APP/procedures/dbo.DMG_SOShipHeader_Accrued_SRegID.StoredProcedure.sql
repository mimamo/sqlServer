USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipHeader_Accrued_SRegID]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipHeader_Accrued_SRegID]
	@CpnyID varchar(10), @RI_WHERE varchar(255)
AS

if RTRIM(@RI_WHERE) <> '' SELECT @RI_WHERE = ' AND (' + @RI_WHERE + ')'

exec('	Select	CpnyID,
		ShipperID,
		InvcNbr
	From	SOShipHeader (NOLOCK)
	Where	Status = ''C''
	And 	ShipRegisterID = ''''
	And 	AccrShipRegisterID = ''''
	And 	Not Exists(Select * From SOEvent (NOLOCK) Where CpnyID = SOShipHeader.CpnyID And ShipperID = SOShipHeader.ShipperID And EventType = ''PINV'')
	And 	ConsolInv = 1
	and	CpnyID = '''+ @CpnyID + '''' + @RI_WHERE)
GO
