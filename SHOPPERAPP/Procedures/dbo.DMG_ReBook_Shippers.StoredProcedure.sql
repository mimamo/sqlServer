USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ReBook_Shippers]    Script Date: 12/21/2015 16:13:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ReBook_Shippers]
as
	declare @CpnyID varchar(10)
	declare @ShipperID varchar(15)
	declare @OrdNbr varchar(15)

	-- Loop through each sales order
	declare TempCursor cursor for select CpnyID, ShipperID, OrdNbr from SOShipHeader
	open TempCursor
	fetch next from TempCursor into @CpnyID, @ShipperID, @OrdNbr

	while (@@fetch_status = 0)
	begin
		if ltrim(rtrim(@OrdNbr)) = '' begin
			execute ADG_Book_Shipper @CpnyID, @ShipperID

			execute DMG_Book_Shipper_Misc @CpnyID, @ShipperID
		end

		fetch next from TempCursor into @CpnyID, @ShipperID, @OrdNbr
	end

	close TempCursor
	deallocate TempCursor

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
