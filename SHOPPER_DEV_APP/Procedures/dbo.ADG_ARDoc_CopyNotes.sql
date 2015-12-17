USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_CopyNotes]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_CopyNotes]
as
	select	convert(smallint, coalesce(CopyNotes, 0))
	from	SOSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
