USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_INSetup]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_INSetup]
as
	select		CurrPerNbr,
			GLPostOpt
	from		INSetup WITH (NOLOCK)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
