USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ReBook_Orders]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ReBook_Orders]
as
	declare @CpnyID varchar(10)
	declare @Ordnbr varchar(15)

	-- Loop through each sales order
	declare TempCursor cursor for select CpnyID, OrdNbr from SOHeader
	open TempCursor
	fetch next from TempCursor into @CpnyID, @OrdNbr

	while (@@fetch_status = 0)
	begin
		execute ADG_Book_Order @CpnyID, @OrdNbr

		execute DMG_Book_Order_Misc @CpnyID, @OrdNbr

		fetch next from TempCursor into @CpnyID, @OrdNbr
	end

	close TempCursor
	deallocate TempCursor

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
