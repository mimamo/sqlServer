USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_Create_Shipper]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOHeader_Create_Shipper]
	@CpnyID varchar(10),
	@OrdNbr varchar(15)
AS
	select	SOHeader.*
	from	SOHeader
	join	SOType on SOType.CpnyID = SOHeader.CpnyID and SOType.SOTypeID = SOHeader.SOTypeID
	where	SOHeader.CpnyID LIKE @CpnyID
	and	SOHeader.OrdNbr LIKE @OrdNbr
	and	SOHeader.Status = 'O'
	and	SOType.Behavior in ('CS','SO','TR','WC')
	and	SOHeader.NextFunctionID = '4041000'
	and	SOHeader.NextFunctionClass = ''
	order by OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
