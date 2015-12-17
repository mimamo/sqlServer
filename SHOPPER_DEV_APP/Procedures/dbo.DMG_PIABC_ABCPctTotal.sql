USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PIABC_ABCPctTotal]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_PIABC_ABCPctTotal]

AS

	select 	sum(ClassPct)
	from 	piabc
	where 	ABCCode in ('A', 'B', 'C')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
