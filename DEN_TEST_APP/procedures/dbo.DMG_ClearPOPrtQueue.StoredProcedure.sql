USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ClearPOPrtQueue]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ClearPOPrtQueue]
as
	delete from poprintqueue

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
