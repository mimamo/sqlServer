USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PIABC_ABCPctTotal]    Script Date: 12/21/2015 16:07:01 ******/
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
